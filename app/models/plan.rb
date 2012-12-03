class Plan < ActiveRecord::Base
  attr_accessible :name, :label, :limit
  has_many :retailers
end
