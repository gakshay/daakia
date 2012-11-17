class Sms < ActiveRecord::Base
  attr_accessible :message, :receiver, :delivered, :status_code
  belongs_to :service, :polymorphic => true
  
  before_create :deliver_sms
  after_create :update_status_code
  
  private
  
  def deliver_sms
    if Rails.env == "production"
      sms = Message::Mobme.new(self.receiver, self.message)
      self.status_code = sms.send 
      sleep(2)
    end
  end
  
  def update_status_code
    self.update_attributes(:status_code => self.status_code) unless self.status_code.blank?
  end
  
end
