# frozen_string_literal: true

module Spree
  module BaseDecorator
    def spree_base_scopes
      return where(product_type: nil) if column_names.include?("product_type")
      super
    end
  end
end

Spree::Base.singleton_class.send :prepend, Spree::BaseDecorator
