ActiveAdmin.register User do
  index do
    column :first_name
    column :last_name
    column :email
    column :mobile
    column :balance
    column :last_sign_in_at
    column :sign_in_count
    column :role_id
    default_actions
  end
  
  
  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :mobile
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :referee 
      f.input :role
    end

    f.buttons
  end
  
  show do |user|
    attributes_table do
      row :id
      row :email
      row :mobile
      row :first_name
      row :last_name
      row :balance
      row :referee
      row :role
      row :sign_in_count
      row :last_sign_in_at
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
  
end
