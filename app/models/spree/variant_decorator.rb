module Spree::VariantDecorator
  def self.prepended(base)

    include Spree::PersistedDynamicAttribute

    base.has_many :prices,
             class_name: 'Spree::Price',
             dependent: :destroy,
             as: :preciable

    base.has_many :rates, class_name: 'Spree::Rate', foreign_key: 'variant_id', dependent: :destroy
    base.belongs_to :calculator, class_name:'Spree::TravelCalculator', foreign_key: 'calculator_id'
    base.has_one :product_type, class_name: 'Spree::ProductType', through: :product
  end

  def option_values_presentation
    option_types_ids = product_type.variant_option_types.pluck(:id)
    option_values.where(option_type_id: option_types_ids).pluck(:presentation)
  end

  def check_price
    # TODO this code is  here to investigate ian issue about normal spree products not been uploaded
    # this can be reproduced by seeding the database and the products will not appear
    if price.nil? && Spree::Config[:require_master_price]
      return errors.add(:base, :no_master_variant_found_to_infer_price)  unless product&.master
      return errors.add(:base, :must_supply_price_for_variant_or_master) if self == product.master

      self.price = product.master.price
    end
    if price.present? && currency.nil?
      self.currency = Spree::Config[:currency]
    end
  end
end

Spree::Variant.prepend Spree::VariantDecorator