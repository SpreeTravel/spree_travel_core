module Spree
  class ProductContextOptionType < ActiveRecord::Base
    belongs_to :product, :class_name => 'Spree::Product', :foreign_key => 'product_id'
    belongs_to :context_option_type, :class_name => 'Spree::OptionType', :foreign_key => 'option_type_id'
  end
end
