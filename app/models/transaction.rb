class Transaction < ActiveRecord::Base
  
  default_scope {where(:active => true)}
  attr_accessible :sender_mobile, :receiver_mobile, :receiver_email, :documents_attributes, :document_secret, :active, :read, :user_id, :retailer_id, :receiver_emails, :sender_email
  attr_accessor :serial_number, :cost
  validates_presence_of :sender_mobile, :if => :sender_mobile_required?
  validates_numericality_of :sender_mobile, :only_integer => true, :allow_blank => true
  validates_format_of :sender_mobile, :with => /(^[789][0-9]{9}$)|(^91[789][0-9]{9}$)/i, :allow_blank => true
  
  validates_format_of :sender_email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, :allow_blank => true
  validates_presence_of :receiver_mobile, :if => :receiver_mobile_required?
  validates_numericality_of :receiver_mobile, :only_integer => true, :allow_blank => true
  validates_format_of :receiver_mobile, :with => /(^[789][0-9]{9}$)|(^91[789][0-9]{9}$)/i, :allow_blank => true
 
  #validates_presence_of :receiver_email, :if => :receiver_email_required?
  validates_format_of :receiver_email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, :allow_blank => true
  validates :documents, :presence => {:message => "There should be atleast one file attached"}
  validates_format_of :receiver_emails, :with => /\A(([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})(\n?\s?)*([,]\s?\n?)*)*\z/i, :allow_blank => true, :message => "is invalid or not comma separated"

  has_many :documents
  accepts_nested_attributes_for :documents
  
  has_many :events
  has_many :smss, :as => :service
  has_many :mail_urls
  belongs_to :user
  belongs_to :retailer
  
  # model hooks
  before_create :assign_sender, :assign_receiver, :generate_document_secret, :clean_multiple_emails
  after_create :update_document_page_count, :debit_balance, :send_recipient_email, :deliver_document_secret_sms, :debit_credit  # , :generate_mail_short_url
  
 
  def self.get_document(mobile, email, secure_code)
    unless (mobile.blank? or email.blank?) and secure_code.blank?
      transaction = Transaction.where("(sender_mobile = ? OR receiver_mobile = ? OR receiver_email = ? or receiver_emails like ?) AND document_secret = ?", mobile, mobile, email, "%#{email}%", secure_code).first
      unless transaction.blank?
        transaction.increment_download_count 
        if (transaction.unread? && (transaction.receiver_mobile == mobile || transaction.receiver_email == email))
          transaction.mark_mail_read
          user = User.where("mobile = :mobile or email = :email", :mobile => mobile, :email => email)
          user.first.decrement_unread_count unless user.blank? # decrement unread count for first user
        end
        transaction 
      end
    end
  end
  
  
  def increment_download_count
    Transaction.increment_counter(:download_count, self.id)
  end
  
  def mark_mail_read
    Transaction.update(self.id, :read => 1)
    #decrement_unread_count(user_id)
  end
  
  def unread?
    !self.read
  end
  
  def other_domain_receiver_email?
    self.receiver_email.match(/@edakia\.in/).nil? unless self.receiver_email.blank?
  end
  
  def other_domain_sender_email?
    self.sender_email.match(/@edakia\.in/).nil? unless self.sender_email.blank?
  end
  
  
  # receive event and make it free for user and retailer right now
  def receive_event(user, serial_number = nil)
    action = "receive"
    return if user.blank?
    unless serial_number.nil?
      machine = Machine.where("serial_number = ?", serial_number).first_or_create!(:serial_number => serial_number)
      cost = 0
      #cost, retailer_cost = self.receive_txn_cost(user) #Price::Receive::PER_PAGE_COST * self.document.pages
      #retailer = self.retailer_txn_balance(retailer_cost, serial_number, action)
      #self.events.create(:machine_id => machine.id, :action => "CSP-#{action}", :user => retailer.mobile, :cost => retailer_cost)
      self.events.create(:machine_id => machine.id, :action => action, :user => user, :cost => cost)
    else
      self.events.create(:action => action, :user => user)
    end
  end
  
  # mail sending cost to the eDakia App user
  def txn_cost
    self.cost = 0
    self.documents.each do |doc|
      self.cost += Price::Send::PER_PAGE_COST * doc.pages
    end
    self.cost
  end
  
  # receive transaction cost to eDakia app user
  def receive_txn_cost(user)
    user = User.where("mobile = ? or email = ?", user, user).select("id, mobile, balance").first
    cost = Price::Receive::PER_PAGE_COST * self.document.pages
    retailer_cost = Price::Receive::RETAILER_PER_PAGE_COST * self.document.pages
    if (user && user.balance > 0.0)
      if user.balance >= cost
        user.balance = user.balance - cost
        cost = 0
        retailer_cost = 0
      # else
      #         cost = cost - user.balance
      #         user.balance = 0
      end
      user.save!
    end
    [cost, retailer_cost]
  end
  
  def retailer_txn_balance(cost, serial_number, event)
    machine = Machine.where("serial_number = ?", "#{serial_number}").includes(:retailer).first
    unless machine.blank?
      machine.retailer.balance = machine.retailer.balance - cost
      machine.retailer.save!
      self.events.create(:machine_id => machine.id, :action => event, :user => self.sender_mobile, :cost => cost)
      Report.notice("Retailer", "#{machine.retailer.mobile} eDakia Kendra. Txn Cost: #{cost} at Machine: #{serial_number}")
      machine.retailer
    end 
  end
  
  protected
  
  def sender_mobile_required?
    self.sender_email.blank?
  end
  
  def receiver_mobile_required?
    self.receiver_email.blank? && self.receiver_emails.blank?
  end

  def receiver_email_required?
    self.receiver_mobile.blank?
  end
  
  private
  
  def assign_sender
    user = User.find_by_mobile(self.sender_mobile, :select => "id")
    self.sender_id = user.id unless user.blank?
    self.sender_email = "#{self.sender_mobile}@edakia.in" if self.sender_email.blank?
  end

  def assign_receiver
    user = User.where("mobile = ? or email = ?", self.receiver_mobile, self.receiver_email).select("id, mobile, email").first
    if !user.blank?
      self.receiver_id = user.id 
      user.increment_unread_count 
      self.receiver_mobile = user.mobile 
      self.receiver_email = user.email   
    elsif !self.receiver_mobile.blank?
      self.receiver_email = nil
    elsif !self.receiver_email.blank?
        self.receiver_mobile = nil
    end
    if !self.receiver_emails.blank?
        self.receiver_emails = nil
    end
  end

  def generate_document_secret
    self.document_secret = "%06d" % rand(10**6) #Time.now.to_i.to_s(36)
  end
  
  def clean_multiple_emails
    unless self.receiver_emails.blank?
      emails = self.receiver_emails.split(",").collect do |e| e.gsub(/(\s*)?(\n*)?(\r*)?/, "") end
      self.receiver_emails = emails.join(",")
    end
  end
  
  def debit_balance
    action = self.sender_mobile == self.receiver_mobile ? "save" : "send"
    unless self.serial_number.blank?
      unless self.retailer_id.blank?
        cost = self.txn_cost
        retailer = self.retailer_txn_balance(cost, self.serial_number, action)
      end
    else
      self.events.create(:action => action, :user => self.sender_mobile)
    end
  end
  
  def generate_mail_short_url
    if Rails.env != "development"
      s_url = ShortUrl.shorten(self.sender_mobile, self.document_secret)
      r_url = self.receiver_mobile.blank? ? "" : ShortUrl.shorten(self.receiver_mobile, self.document_secret)
      self.mail_urls.create(:sender_url => s_url, :receiver_url => r_url)
    end
  end

  def deliver_document_secret_sms
    # code to send sms to sender and receiver
    time = self.created_at.strftime("%d-%b-%Y %I:%M")
    unless self.serial_number.blank?
      unless self.retailer_id.blank? # machine based retailer txn
        if !self.sender_mobile.blank? #always send sms to sender
          receiver = self.receiver_mobile.blank? ? self.receiver_emails.split(",").first : self.receiver_mobile
          sender_template = Message.general_request_replied("Mail", "#{self.document_secret} To: #{receiver} Txn Cost: #{self.cost}", time)
          self.smss.create(:receiver => self.sender_mobile, :message => sender_template)
        end
        # send sms to receiver if sender and recipient are different
        if !self.receiver_mobile.blank? and (self.receiver_mobile != self.sender_mobile) 
          sender = self.sender_mobile.blank? ? self.sender_email : self.sender_mobile
          receiver_template = Message.document_receiver_template(sender, self.document_secret, time)
          self.smss.create(:receiver => self.receiver_mobile, :message => receiver_template)
        end
      end
    else # web based retailer or user transaction sms
      if !self.retailer_id.blank? or !self.user_id.blank?
        # send sms to sender only if sender and recipient are different
        if !self.sender_mobile.blank? 
          receiver = self.receiver_mobile.blank? ? self.receiver_emails.split(",").first : self.receiver_mobile
          sender_template = Message.general_request_replied("Mail", "#{self.document_secret} To: #{receiver}", time)
          self.smss.create(:receiver => self.sender_mobile, :message => sender_template)
        end
        # always send sms to recipient
        if !self.receiver_mobile.blank? and (self.receiver_mobile != self.sender_mobile)
          sender = self.sender_mobile.blank? ? self.sender_email : self.sender_mobile
          receiver_template = Message.document_receiver_template(sender, self.document_secret, time)
          self.smss.create(:receiver => self.receiver_mobile, :message => receiver_template)
        end
      end
    end
  end
  
  def send_recipient_email
    unless self.receiver_email.blank?
      TransactionMailer.send_recipient_email(self).deliver! if self.other_domain_receiver_email?
    end
    unless self.receiver_emails.blank?
      TransactionMailer.send_multiple_recipient_emails(self).deliver!
    end
  end
  
  def debit_credit
    if self.serial_number.blank?
      unless self.retailer_id.blank?
        self.retailer.credit -= 1
        self.retailer.save!
      end
    end
    unless self.user_id.blank?
      self.user.credit -= 1
      self.user.save!
    end
  end
  
    
  def update_document_page_count
    formats = %w(application/vnd.openxmlformats-officedocument.presentationml.presentation 
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
    application/msword
    application/vnd.ms-powerpoint
    )
    self.documents.each do |document|
      if document.doc_content_type == "application/pdf"
        require 'open-uri' unless defined?(OpenURI)
        begin
          io = open(document.doc.url(:original, false))
          reader = PDF::Reader.new(io)
          document.pages = reader.page_count
          document.save
        rescue => ex
          Report.error("document", "PDF Page count failed #{ex}")
        end  
      elsif formats.include?(document.doc_content_type)
        begin
          yomu = Yomu.new(document.doc.url(:original, false))
          metadata = yomu.metadata
          unless metadata['xmpTPg:NPages'].blank?
            document.pages = metadata['xmpTPg:NPages']
            document.save
          end
        rescue => ex
          Report.error("document", "Yomu Page count failed for document #{document.doc_file_name} #{ex}")
        end
      end 
    end 
  end #update document page count
  
end #model transaction
