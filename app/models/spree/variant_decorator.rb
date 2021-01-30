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
end

Spree::Variant.prepend Spree::VariantDecorator