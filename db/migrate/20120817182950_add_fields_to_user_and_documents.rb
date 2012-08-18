class AddFieldsToUserAndDocuments < ActiveRecord::Migration
  def change
    add_column :users, :referral_token, :string, :limit => 64
    add_column :users, :balance, :float, :default => 0.0
    add_column :users, :referee_id, :integer
    add_column :documents, :pages, :integer, :default => 1
    add_index :users, :balance
    add_index :documents, :pages
  end
end
