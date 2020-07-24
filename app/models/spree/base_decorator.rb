# frozen_string_literal: true

module Spree
  module BaseDecorator
    def spree_base_scopes
      where(product_type: nil)
    end
  end
end

Spree::Base.singleton_class.send :prepend, Spree::BaseDecorator
