module Spree
  class ProductType < ActiveRecord::Base
  
    has_and_belongs_to_many :rate_option_types,
      :join_table => :spree_product_type_rate_option_types,
      :class_name => 'Spree::OptionType',
      :foreign_key => 'product_type_id',
      :association_foreign_key => 'rate_option_type_id'
    has_and_belongs_to_many :context_option_types,
      :join_table => :spree_product_type_context_option_types,
      :class_name => 'Spree::OptionType',
      :foreign_key => 'product_type_id',
      :association_foreign_key => 'context_option_type_id'

    def self.enabled
      where(:enabled => true)
    end

  end
end
