module Spree::AppConfigurationDecorator
  def self.prepended(base)
    base.preference :use_cart, :boolean, default: true #true if you want to have a cart or false will directly to the checkout process with one product only
  end
end

Spree::AppConfiguration.prepend Spree::AppConfigurationDecorator