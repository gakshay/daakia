ActiveAdmin.register Event do
  menu :label => "Transactions", :parent => "Mails"
  actions  :index, :show
  
  index do
    column "Machine", :machine_id
    column :user
    column :action
    column :cost
    column :created_at
    default_actions
  end
  
end
