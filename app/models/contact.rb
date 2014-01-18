class Contact < ActiveRecord::Base
  attr_accessible :email, :message, :mobile, :name, :company
  validates_presence_of :email, :mobile, :name, :message
  
  validates_format_of :mobile, :with => /(^[789][0-9]{9}$)|(^91[789][0-9]{9}$)/i
  validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i

  after_create :send_contact_us_email 
  
  private
  
  def send_contact_us_email
    unless self.email.blank?
      ContactMailer.contact_us_mail(self).deliver!
    end
  end 
end
