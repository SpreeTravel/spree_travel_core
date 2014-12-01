module Spree
  class Combinations < ActiveRecord::Base

    belongs_to :product, :class => 'Spree::Product' , :foreign_key => 'product_id'
    belongs_to :rate, :class => 'Spree::Rate' , :foreign_key => 'rate_id'
  end
end
