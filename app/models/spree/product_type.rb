# frozen_string_literal: true

module Spree
  class ProductType < Spree::Base
    default_scope { where(enabled: true) }

    has_and_belongs_to_many :rate_option_types,
                            join_table: :spree_product_type_rate_option_types,
                            class_name: 'Spree::OptionType',
                            foreign_key: 'product_type_id',
                            association_foreign_key: 'rate_option_type_id'
    has_and_belongs_to_many :context_option_types,
                            join_table: :spree_product_type_context_option_types,
                            class_name: 'Spree::OptionType',
                            foreign_key: 'product_type_id',
                            association_foreign_key: 'context_option_type_id'
    has_and_belongs_to_many :variant_option_types,
                            join_table: :spree_product_type_variant_option_types,
                            class_name: 'Spree::OptionType',
                            foreign_key: 'product_type_id',
                            association_foreign_key: 'variant_option_type_id'
    has_one :calculator,
            class_name: 'Spree::TravelCalculator',
            foreign_key: 'product_type_id'

    validates_presence_of :name, :presentation
    validates_uniqueness_of :name

    # Modified enabled definition, to exclude product product_type, for lacking of relevance
    def self.enabled
      where(enabled: true)
    end
  end
end
