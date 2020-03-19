module Spree
  class RateOptionValue < Spree::Base
    belongs_to :rate, class_name: 'Spree::Rate', foreign_key: 'rate_id', required: false
    belongs_to :option_value, class_name: 'Spree::OptionValue', foreign_key: 'option_value_id', required: false

    include Spree::DefaultPrice

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
      return unless option_value&.option_type&.preciable?

      self.price = self.value if price.nil?

      if price.present? && currency.nil?
        self.currency = Spree::Config[:currency]
      end
    end
  end
end
