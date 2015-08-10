module Spree
  class Combinations < ActiveRecord::Base

    #TODO aqui hay que borrarlo en cascada
    belongs_to :product, :class_name => 'Spree::Product', :foreign_key => 'product_id'
    belongs_to :rate, :class_name => 'Spree::Rate', :foreign_key => 'rate_id'
    belongs_to :variant, :class_name => 'Spree::Variant', :foreign_key => 'variant_id'


    def product
      Spree::Product.find product_id
    end

    def rate
      Spree::Rate.find rate_id
    end

    def variant
      Spree::Variant.find variant_id
    end

  end
end
