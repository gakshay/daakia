class Event < ActiveRecord::Base
  attr_accessible :action, :user, :cost, :machine_id
  belongs_to :transaction, :conditions => "active=1"
  belongs_to :machine, :counter_cache => true
end
