class AddUnreadCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :unread_count, :integer, :default => 0
  end
end
