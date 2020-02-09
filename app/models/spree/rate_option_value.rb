module Spree
  class RateOptionValue < Spree::Base
    belongs_to :rate, class_name: 'Spree::Rate', foreign_key: 'rate_id', required: false
    belongs_to :option_value, class_name: 'Spree::OptionValue', foreign_key: 'option_value_id', required: false

    validates_presence_of :value
  end
end
