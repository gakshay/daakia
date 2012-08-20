ActiveAdmin.register Transaction do
  menu :label => "Mails"
  actions  :index, :new, :create, :show, :destroy
  
  index do
    column :sender_mobile
    column :receiver_mobile
    column :receiver_email
    column "D/L Count", :download_count
    column :read
    column :created_at
    default_actions
  end
  
end
