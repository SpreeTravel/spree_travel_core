module Spree::ProductDecorator
  def self.prepended(base)
    require 'ffaker'

    base.belongs_to :product_type
    base.belongs_to :calculator, :class_name => 'Spree::TravelCalculator', :foreign_key => 'calculator_id'
    base.has_many :rates, :through => :variants_including_master

    base.after_create :absorb_option_types
    base.whitelisted_ransackable_attributes << 'product_type_id'

    base.delegate :rate_option_types, to: :product_type, prefix: false, allow_nil: true
    base.delegate :context_option_types, to: :product_type, prefix: false, allow_nil: true
    base.delegate :variant_option_types, to: :product_type, prefix: false, allow_nil: true
  end

  # self.whitelisted_ransackable_attributes << 'product_type_id'

  def absorb_option_types
    if product_type.present?
      self.option_types = self.product_type.variant_option_types
    end
  end

  def calculator_instance
    calculator.name.constantize.new
  end

  def calculate_price(context, variant, options)
    # calculator_instance.calculate_price(context, self, options).sort
    calculator_instance.calculate_price(context, self, variant, options)
  end

  def destination_taxon
    destination_taxonomy = Spree::Taxonomy.where(:name => 'Destination').first
    self.taxons.where(:taxonomy_id => destination_taxonomy.id).first
  rescue
    nil
  end

  def destination
    destination_taxon.name rescue "no place"
  end

  private

  def self.ransackable_scopes(auth_object = nil)
    [:product_type_id]
  end
end

Spree::Product.prepend Spree::ProductDecorator

module Spree::ProductDecoratorClassMethod
  def calculator_instance_for(product_type)
    product_type.calculator.name.constantize.new
  end
end

Spree::Product.singleton_class.send :prepend, Spree::ProductDecoratorClassMethod
