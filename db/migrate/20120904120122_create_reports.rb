class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :category
      t.string :severity
      t.text :message
      t.timestamps
    end
  end
end
