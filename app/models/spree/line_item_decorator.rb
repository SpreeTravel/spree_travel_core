# frozen_string_literal: true

module Spree
  module LineItemDecorator
    def self.prepended(base)
      base.has_many :paxes, class_name: 'Spree::Pax', dependent: :destroy
      base.belongs_to :context, class_name: 'Spree::Context'
      base.belongs_to :rate, class_name: 'Spree::Rate'

      base.accepts_nested_attributes_for :paxes
      base.accepts_nested_attributes_for :context

      base.attr_accessor :context_price
    end

    def context_attributes=(attr)
      return if attr.nil?

      context.persist_option_values(attr)

      copy_price
    end

    def copy_price
      return unless variant

      line_item_price
      self.cost_price = variant.cost_price if cost_price.nil?
      self.currency = variant.currency if currency.nil?
    end

    private

    def line_item_price
      if variant.product_type.present?
        variant.calculate_price(context, temporal: false)
        self.price = variant.context_price.to_i
      elsif price.nil?
        update_price
      end
    end
  end
end

Spree::LineItem.prepend Spree::LineItemDecorator
