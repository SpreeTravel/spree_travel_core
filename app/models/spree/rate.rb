module Spree
  class Rate < ActiveRecord::Base
    belongs_to :variant, :class_name => 'Spree::Variant', :foreign_key => 'variant_id'
  end
end
