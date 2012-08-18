class Sms < ActiveRecord::Base
  attr_accessible :message, :receiver, :delivered
  belongs_to :service, :polymorphic => true
end
