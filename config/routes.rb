DakiaWeb::Application.routes.draw do
  
  devise_for :retailers, :path_names => { :sign_in => 'login', :sign_out => 'logout'}

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :transactions do
    get :receive, :on => :collection
    post :download, :on => :member
    get :retailer_txn, :on => :collection
  end

  #resources :documents

  #devise_for :users, :controllers => { :registrations => "registrations" }, :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'register' }
  devise_for :users, :skip => [:registrations], :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'register' }                                     
      as :user do
        get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'    
        put 'users' => 'devise/registrations#update', :as => 'user_registration'            
      end
      
  get "home/index"
  root :to => "home#index"
  
  namespace :api do
    resources :users, :only => [:index, :show, :destroy, :edit] do
      post :update_password, :on => :collection
      get :register, :on => :collection, :defaults => { :format => 'xml' }
    end
    resources :transactions, :only => [:create, :show] do
      get :receive, :on => :collection
    end
  end
  
  namespace :retailers do
    resources :transactions, :only => [:index, :destroy, :new, :create, :show]
  end
  
  match 'receive' => 'transactions#receive'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
