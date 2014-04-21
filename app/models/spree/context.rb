module Spree
  class Context < ActiveRecord::Base
    belongs_to :line_item, :class_name => 'Spree::LineItem', :foreign_key => 'line_item_id'
    has_many :option_values, :class_name => 'Spree::ContextOptionValue', :foreign_key => 'context_id', :dependent => :destroy
  end
end
