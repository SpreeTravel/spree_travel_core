# frozen_string_literal: true

module Spree
  module AppConfigurationDecorator
    def self.prepended(base)
      base.preference :use_cart, :boolean, default: true # true if you want to have a cart or false will directly to the checkout process with one product only
    end
  end
end

Spree::AppConfiguration.prepend Spree::AppConfigurationDecorator
