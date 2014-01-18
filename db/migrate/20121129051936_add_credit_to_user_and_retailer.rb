class AddCreditToUserAndRetailer < ActiveRecord::Migration
  def change
    add_column :users, :credit, :integer, :default => 10
    add_column :retailers, :plan_id, :integer, :default => 1
    add_column :retailers, :credit, :integer, :default => 150
  end
end
