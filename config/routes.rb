Spree::Core::Engine.routes.draw do
  # Add your extension routes here

  post 'products/get_ajax_price'

  patch 'line_items/update/:id' => 'line_items#update', :as => 'line_items_update'

  resources :paxes

end
