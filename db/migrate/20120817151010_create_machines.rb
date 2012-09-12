class CreateMachines < ActiveRecord::Migration
  def change
    create_table :machines do |t|
      t.string :brand
      t.string :serial_number
      t.string :deviceid
      t.string :manufacturer
      t.string :model
      t.string :product
      t.integer :events_count, :default => 0
      t.integer :retailer_id
      t.timestamps
    end
    add_index :machines, :serial_number,     :unique => true
    add_index :machines, :events_count
    add_index :machines, :retailer_id
  end
end
