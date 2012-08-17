class AddMobileToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :mobile, :string, :limit => 64
  end
end
