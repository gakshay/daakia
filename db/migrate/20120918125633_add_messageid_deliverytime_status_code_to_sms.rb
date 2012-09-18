class AddMessageidDeliverytimeStatusCodeToSms < ActiveRecord::Migration
  def change
    add_column :sms, :messageid, :string
    add_column :sms, :delivery_time, :timestamp
    add_column :sms, :status_code, :string, :limit => 64
    add_index :sms, :messageid
  end
end
