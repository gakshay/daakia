ActiveAdmin.register Document do
  menu :label => "Files"
  actions  :index, :new, :create, :show, :destroy
  
  index do
    column "File Name", :doc_file_name
    column "File Type", :doc_content_type
    column "File Size", :doc_file_size
    column :direct_url
    column :pages
    column :doc_updated_at
    default_actions
  end
end
