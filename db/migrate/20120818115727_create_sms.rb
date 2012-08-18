class CreateSms < ActiveRecord::Migration
  def change
    create_table :sms do |t|
      t.string :receiver
      t.string :message
      t.references :service, :polymorphic => true
      t.boolean :delivered, :default => false

      t.timestamps
    end
  end
end
