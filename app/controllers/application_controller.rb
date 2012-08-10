class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "main"
  
  def after_sign_in_path_for(resource)
   transactions_path
  end
end
