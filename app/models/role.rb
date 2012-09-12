class Role < ActiveRecord::Base
  attr_accessible :name, :title
  has_many :users
end
