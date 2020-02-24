module Spree::PriceDecorator
  def self.prepended(base)
    base.belongs_to :preciable, polymorphic: true
  end

  def price_including_vat_for(price_options)
    options = if preciable.respond_to?(:rate)
                price_options.merge(tax_category: preciable.rate.variant.tax_category)
              else
                price_options.merge(tax_category: preciable.tax_category)
              end
    gross_amount(price, options)
  end
end

Spree::Price.prepend Spree::PriceDecorator