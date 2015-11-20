Spree::AppConfiguration.class_eval do
  #if you want to have a cart or directly to the checkout process
  preference :use_cart, :boolean, default: false 
end