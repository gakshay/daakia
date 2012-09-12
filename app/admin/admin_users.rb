ActiveAdmin.register AdminUser do
  menu false
  index do
    column :email
    column :mobile
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end
  
  form do |f|
    f.inputs "Admin Details" do
      f.input :mobile
      f.input :email
    end
    f.buttons
  end
  
  show do |ad|
    attributes_table do
      row :email
      row :mobile
      row :last_sign_in_at
    end
    active_admin_comments
  end
  
end
