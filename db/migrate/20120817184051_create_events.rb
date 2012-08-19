class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :transaction_id
      t.integer :machine_id
      t.string :user
      t.string :action, :limit => 64
      t.string :current_event_ip
      t.float :cost, :default => 0.0
      t.timestamps
    end
    add_index :events, :machine_id
    add_index :events, :transaction_id
  end
end
