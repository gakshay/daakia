class AddTransactionCounters < ActiveRecord::Migration
  def change
    add_column :transactions, :active, :boolean, :default => true
    add_column :transactions, :download_count, :integer, :default => 0
    add_column :transactions, :read, :boolean, :default => false
  end
end
