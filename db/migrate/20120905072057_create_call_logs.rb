class CreateCallLogs < ActiveRecord::Migration
  def change
    create_table :call_logs do |t|
      t.string :caller, :limit => 64
      t.string :sid, :limit => 64
      t.string :called_number, :limit => 64
      t.string :event, :limit => 64
      t.string :circle, :limit => 64
      t.string :operator, :limit => 64
      t.integer :duration

      t.timestamps
    end
    add_index :call_logs, :sid, :unique => true
    add_index :call_logs, :caller
  end
end
