# frozen_string_literal: true

module Spree
  class RateOptionValue < Spree::Base
    include Spree::RateContextMethods
    include Spree::DefaultPrice

    belongs_to :rate, class_name: 'Spree::Rate', foreign_key: 'rate_id', required: false
    belongs_to :option_value, class_name: 'Spree::OptionValue', foreign_key: 'option_value_id', required: false
    has_one :value, as: :valuable
    has_many :prices,
             class_name: 'Spree::Price',
             dependent: :destroy,
             as: :preciable

    validate :check_price
    validates_numericality_of :price, greater_than_or_equal_to: 0, allow_nil: true

    def price_in(currency)
      prices.detect { |price| price.currency == currency } || prices.build(currency: currency)
    end

    def amount_in(currency)
      price_in(currency).try(:amount)
    end

    private

    def check_price
      return unless option_value&.option_type&.attr_type == 'price'

      self.price = value if price.nil?

      self.currency = Spree::Config[:currency] if price.present? && currency.nil?
    end
  end
end
