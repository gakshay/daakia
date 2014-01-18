class AddFieldsToTransactionAndDocument < ActiveRecord::Migration
  def change
    add_column :transactions, :sender_email, :string
    add_column :documents, :transaction_id, :integer
    add_column :transactions, :user_id, :integer
    add_column :transactions, :retailer_id, :integer
    add_column :transactions, :receiver_emails, :text
    remove_column :transactions, :sms_sent
    remove_column :transactions, :sms_count
    remove_column :transactions, :sms_sent_time
  end
end
