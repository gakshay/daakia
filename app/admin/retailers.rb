ActiveAdmin.register Retailer do
  menu :label => "Retailers"
  
  index do
    column :first_name
    column :last_name
    column :email
    column :mobile
    column :balance
    column :credit
    column :last_sign_in_at
    default_actions
  end
  
  
  form do |f|
    f.inputs do
      f.input :mobile
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :balance
      f.input :age
      f.input :address, :input_html => {:rows => 3}
      f.input :city
      f.input :state
      f.input :pincode
      f.input :credit
      f.input :plan
    end

    f.buttons
  end
end
