class Machine < ActiveRecord::Base
  attr_accessible :brand, :deviceid, :event_count, :manufacturer, :model, :product, :retailer_id, :serial_number
  
  validates_presence_of :serial_number
  belongs_to :retailer
  
end
