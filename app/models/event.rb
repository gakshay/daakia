class Event < ActiveRecord::Base
  attr_accessible :action, :user, :cost, :machine_id
  belongs_to :transaction
  belongs_to :machine
end
