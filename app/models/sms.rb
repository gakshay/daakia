class Sms < ActiveRecord::Base
  attr_accessible :message, :receiver, :delivered, :status_code
  belongs_to :service, :polymorphic => true
  
  before_create :deliver_sms
  after_create :update_status_code
  
  private
  
  def deliver_sms
    sms = Message::Mobme.new(self.receiver, self.message)
    self.status_code = sms.send unless Rails.env == "development"
    sleep(3)
  end
  
  def update_status_code
    self.update_attributes(:status_code => self.status_code)
  end
  
end
