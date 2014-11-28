module Spree
  class Combinations < ActiveRecord::Base
    belongs_to :product, :class => 'Spree::Product', , :foreign_key => 'product_id'
  end
end
