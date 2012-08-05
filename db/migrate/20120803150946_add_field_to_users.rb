class AddFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string, :limit => 64
    add_column :users, :middle_name, :string, :limit => 64
    add_column :users, :last_name, :string, :limit => 64
    add_column :users, :mobile, :string, :limit => 64
    add_column :users, :age, :integer
    add_column :users, :gender, :string, :limit => 10 
    add_column :users, :address, :text 
    add_column :users, :city, :string, :limit => 64 
    add_column :users, :state, :string, :limit => 64 
    add_column :users, :pincode, :string, :limit => 10 
    add_index :users, :mobile
  end
end
