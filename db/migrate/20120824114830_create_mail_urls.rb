class CreateMailUrls < ActiveRecord::Migration
  def change
    create_table :mail_urls do |t|
      t.integer :transaction_id
      t.string :sender_url, :limit => 64
      t.string :receiver_url, :limit => 64

      t.timestamps
    end
  end
end
