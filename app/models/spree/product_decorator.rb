# frozen_string_literal: true

module Spree
  module ProductDecorator
    def self.prepended(base)
      require 'ffaker'

      base.belongs_to :product_type
      base.belongs_to :calculator, class_name: 'Spree::TravelCalculator', foreign_key: 'calculator_id'
      base.has_many :rates, through: :variants_including_master, dependent: :destroy

      base.after_create :absorb_option_types
      base.whitelisted_ransackable_attributes << 'product_type_id'

      base.delegate :rate_option_types, to: :product_type, prefix: false, allow_nil: true
      base.delegate :context_option_types, to: :product_type, prefix: false, allow_nil: true
      base.delegate :variant_option_types, to: :product_type, prefix: false, allow_nil: true
    end

    # self.whitelisted_ransackable_attributes << 'product_type_id'

    def absorb_option_types
      self.option_types = product_type.variant_option_types if product_type.present?
    end

    private

    def self.ransackable_scopes(_auth_object = nil)
      [:product_type_id]
    end
  end
end

Spree::Product.prepend Spree::ProductDecorator

module Spree
  module ProductDecoratorClassMethod
    def calculator_instance_for(product_type)
      product_type.calculator.name.constantize.new
    end
  end
end

Spree::Product.singleton_class.send :prepend, Spree::ProductDecoratorClassMethod
