module Spree
  class ProductRateOptionType < ActiveRecord::Base
    belongs_to :product, :class_name => 'Spree::Product', :foreign_key => 'product_id'
    belongs_to :rate_option_type, :class_name => 'Spree::OptionType', :foreign_key => 'option_type_id'
  end
end
