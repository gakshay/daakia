class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "main"
  
  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      transactions_path
    else
      super
    end
  end
end
