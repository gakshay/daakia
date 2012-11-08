class Transaction < ActiveRecord::Base
  
  default_scope {where(:active => true)}
  attr_accessible :sender_mobile, :receiver_mobile, :receiver_email, :document_attributes, :document_secret, :active, :read
  attr_accessor :serial_number, :cost
  validates_presence_of :sender_mobile
  validates_numericality_of :sender_mobile, :only_integer => true, :allow_nil => true
  validates_format_of :sender_mobile, :with => /(^[789][0-9]{9}$)|(^91[789][0-9]{9}$)/i, :allow_blank => true
  
  validates_presence_of :receiver_mobile, :if => :receiver_mobile_required?
  validates_numericality_of :receiver_mobile, :only_integer => true, :if => :receiver_mobile_required?
  validates_format_of :receiver_mobile, :with => /(^[789][0-9]{9}$)|(^91[789][0-9]{9}$)/i, :allow_blank => true
 
  validates_presence_of :receiver_email, :if => :receiver_email_required?
  validates_format_of :receiver_email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, :allow_blank => true

  belongs_to :document
  accepts_nested_attributes_for :document
  
  has_many :events
  has_many :smss, :as => :service
  has_many :mail_urls
  
  # model hooks
  before_create :assign_sender, :assign_receiver, :generate_document_secret
  after_create :update_document_page_count, :send_recipient_email, :deliver_document_secret_sms  # , :generate_mail_short_url
  
 
  def self.get_document(mobile, email, secure_code)
    unless (mobile.blank? or email.blank?) and secure_code.blank?
      transaction = Transaction.where("(sender_mobile = ? OR receiver_mobile = ? OR receiver_email = ?) AND document_secret = ?", mobile, mobile, email, secure_code).first
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
  
  # events handling
  
  def send_event(serial_number = nil)
    action = self.sender_mobile == self.receiver_mobile ? "save" : "send"
    unless serial_number.nil?
      machine = Machine.where("serial_number = ?", serial_number).first_or_create!(:serial_number => serial_number)
      cost = self.cost #Price::Send::PER_PAGE_COST * self.document.pages
      retailer = self.retailer_txn_balance(cost, serial_number)
      self.events.create(:machine_id => machine.id, :action => "CSP-#{action}", :user => retailer.mobile, :cost => cost)
      self.events.create(:machine_id => machine.id, :action => action, :user => self.sender_mobile, :cost => cost)
    else
      self.events.create(:action => action, :user => self.sender_mobile)
    end
  end
  
  def receive_event(user, serial_number = nil)
    action = "receive"
    return if user.blank?
    unless serial_number.nil?
      machine = Machine.where("serial_number = ?", serial_number).first_or_create!(:serial_number => serial_number)
      cost, retailer_cost = self.receive_txn_cost(user) #Price::Receive::PER_PAGE_COST * self.document.pages
      retailer = self.retailer_txn_balance(retailer_cost, serial_number)
      self.events.create(:machine_id => machine.id, :action => "CSP-#{action}", :user => retailer.mobile, :cost => retailer_cost)
      self.events.create(:machine_id => machine.id, :action => action, :user => user, :cost => cost)
    else
      self.events.create(:action => action, :user => user)
    end
  end
  
  # mail sending cost to the eDakia App user
  def txn_cost
    # if self.document.pages == 1
    #   self.cost =  Price::Send::SINGLE_PAGE_COST
    # else
    #   self.cost = Price::Send::PER_PAGE_COST * self.document.pages
    # end
    self.cost = Price::Send::PER_PAGE_COST * self.document.pages
    user = User.where("id = ?", self.sender_id).select("id, mobile, balance").first
    if (user && user.balance > 0.0)
      if user.balance >= self.cost
        user.balance = user.balance - self.cost
        self.cost = 0
      else
        self.cost = self.cost - user.balance
        user.balance = 0
      end
      user.save!
    end
    self.cost
  end
  
  # receive transaction cost to eDakia app user
  def receive_txn_cost(user)
    user = User.where("mobile = ? or email = ?", user, user).select("id, mobile, balance").first
    # if self.document.pages <= 5
    #       cost =  Price::Receive::PER_PAGE_COST
    #     else
    #       cost = Price::Receive::PER_PAGE_COST * 2
    #     end
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
  
  def retailer_txn_balance(cost, serial_number)
    machine = Machine.where("serial_number = ?", "#{serial_number}").includes(:retailer).first
    unless machine.blank?
      machine.retailer.balance = machine.retailer.balance - cost
      machine.retailer.save!
      Report.notice("Retailer", "#{machine.retailer.mobile} eDakia Kendra. Txn Cost: #{cost} at Machine: #{serial_number}")
    end 
    machine.retailer
  end
  
  protected
  
  def receiver_mobile_required?
    self.receiver_email.blank?
  end

  def receiver_email_required?
    self.receiver_mobile.blank?
  end
  
  private
  
  def assign_sender
    user = User.find_by_mobile(self.sender_mobile, :select => "id")
    self.sender_id = user.id unless user.blank?
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
  end

  def generate_document_secret
    self.document_secret = "%06d" % rand(10**6) #Time.now.to_i.to_s(36)
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
    receiver = self.receiver_mobile.blank? ? self.receiver_email : self.receiver_mobile
    time = self.created_at.strftime("%d-%b-%Y %I:%M")
    cost = self.serial_number.blank? ? 0 : self.txn_cost
    sender = User.find_by_mobile(self.sender_mobile, :select => "id, balance")
    balance = sender.balance
    sender_template = Message.document_sender_success_template(cost, self.document_secret, receiver, time, balance)
    unless self.receiver_mobile.blank?
      if self.other_domain_receiver_email?
        receiver_template = Message.document_receiver_email_registered_template(self.sender_mobile, self.document_secret, time, self.receiver_email)
      else
        receiver_template = Message.document_receiver_template(self.sender_mobile, self.document_secret, time)
      end
      #deliver receiver sms
      self.smss.create(:receiver => self.receiver_mobile, :message => receiver_template)
    end
    # deliver sender sms
    self.smss.create(:receiver => self.sender_mobile, :message => sender_template)
  end
  
  def send_recipient_email
    unless self.receiver_email.blank?
      TransactionMailer.send_recipient_email(self).deliver if self.other_domain_receiver_email?
    end
  end

    
  def update_document_page_count
    formats = %w(application/vnd.openxmlformats-officedocument.presentationml.presentation 
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
    application/msword
    application/vnd.ms-powerpoint
    )
    if self.document.doc.content_type == "application/pdf"
      require 'open-uri' unless defined?(OpenURI)
      begin
        io = open(self.document.doc.url(:original, false))
        reader = PDF::Reader.new(io)
        self.document.pages = reader.page_count
        self.document.save
      rescue => ex
        Report.error("document", "PDF Page count failed #{ex}")
      end  
    elsif formats.include?(self.document.doc.content_type)
      begin
        yomu = Yomu.new(self.document.doc.url(:original, false))
        metadata = yomu.metadata
        unless metadata['xmpTPg:NPages'].blank?
          self.document.pages = metadata['xmpTPg:NPages']
          self.document.save
        end
      rescue => ex
        Report.error("document", "Yomu Page count failed #{ex}")
      end
    end  
  end #update document page count
  
end #model transaction
