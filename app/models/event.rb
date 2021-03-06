class Event < ActiveRecord::Base
  attr_accessible :action, :user, :cost, :machine_id
    
  belongs_to :transaction
  belongs_to :machine, :counter_cache => true
  
  validates_presence_of :user
  validates_presence_of :transaction_id
  validates_presence_of :action
end
