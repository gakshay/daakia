class AddShopNameToRetailers < ActiveRecord::Migration
  def change
    add_column :retailers, :shop_name, :string
  end
end
