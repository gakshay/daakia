class Transaction < ActiveRecord::Base
  
  default_scope {where(:active => true)}
  attr_accessible :sender_mobile, :receiver_mobile, :receiver_email, :document_attributes, :document_secret, :active, :read
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
  has_many :smses, :as => :service
  has_many :mail_urls
 
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
    else
      record.errors.add(document_secret, "secret is wrong") if secure_code.blank?
    end
  end

  
  # model hooks
  before_create :assign_sender, :assign_receiver, :generate_document_secret
  after_create :generate_mail_url, :deliver_document_secret_sms, :send_recipient_email

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
  
  def generate_mail_url
    if Rails.env != "development"
      s_url = ShortUrl.shorten(self.sender_mobile, self.document_secret)
      r_url = self.receiver_mobile.blank? ? "" : ShortUrl.shorten(self.receiver_mobile, self.document_secret)
      self.mail_urls.create(:sender_url => s_url, :receiver_url => r_url)
    end
  end

  def deliver_document_secret_sms
    # code to send sms to sender and receiver
    #unless self.receiver_mobile.blank?
    #  sms = SMS::Smscraze.new(self.sender_mobile, self.receiver_mobile, self.document_secret, self.document.doc.url(:original,false))
    #  sms.deliver_document_sms
    #end
  end
  
  def send_recipient_email
    unless self.receiver_email.blank?
      TransactionMailer.send_recipient_email(self).deliver if self.other_domain_receiver_email?
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
    self.receiver_email.match(/@edakia\.in/).nil?
  end
  
  # events handling
  
  def send_event(serial_number = nil)
    action = self.sender_mobile == self.receiver_mobile ? "save" : "send"
    unless serial_number.nil?
      machine = Machine.where("serial_number = ?", serial_number).first_or_create!(:serial_number => serial_number)
      cost = Price::Send::PER_PAGE_COST * self.document.pages
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
      cost = Price::Receive::PER_PAGE_COST * self.document.pages
      self.events.create(:machine_id => machine.id, :action => action, :user => user, :cost => cost)
    else
      self.events.create(:action => action, :user => user)
    end
  end

  protected
  
  def receiver_mobile_required?
    self.receiver_email.blank?
  end

  def receiver_email_required?
    self.receiver_mobile.blank?
  end
end
