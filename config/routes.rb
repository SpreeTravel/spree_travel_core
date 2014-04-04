Spree::Core::Engine.routes.draw do
  # Add your extension routes here

  post 'products/get_ajax_price'

  patch 'line_items/update/:id' => 'line_items#update', :as => 'line_items_update'

  resources :paxes
  
  namespace :admin do
    resources :product_types
    resources :products do
      resources :rates
    end
  end
  
  #get 'admin/products/:permalink/rates/' => 'admin/rates#index', :as => 'admin_rates'
  
  #get 'admin/products/:permalink/rates/new' => 'admin/rates#new', :as => 'new_admin_rate' 
  #post 'admin/products/:permalink/rates/create' => 'admin/rates#create', :as => 'create_admin_rate' 
  #post 'admin/products/:permalink/rates/update' => 'admin/rates#update', :as => 'update_admin_rate'

end
