# frozen_string_literal: true

module Spree
  module PrototypeDecorator
    def self.prepended(base)
      base.belongs_to :product_type, class_name: 'Spree::ProductType', foreign_key: 'product_type_id'
    end
  end
end
