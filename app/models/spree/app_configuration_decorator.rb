Spree::AppConfiguration.class_eval do
  preference :use_cart, :boolean, default: false #if you want to have a cart or directly to the checkout process
end