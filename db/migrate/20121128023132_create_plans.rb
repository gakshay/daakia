class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.string :label
      t.integer :limit
      t.timestamps
    end
    
    plans = Plan.create!([{:name => "free", :label => "Free Credit", :limit => 150}, 
      {:name => "transactional", :label => "Pay Per Use", :limit => 0},
      {:name => "small", :label => "Small Pack", :limit => 100},
      {:name => "medium", :label => "Medium Pack", :limit => 300},
      {:name => "large", :label => "Large Pack", :limit => 750}
      ])
  end
end
