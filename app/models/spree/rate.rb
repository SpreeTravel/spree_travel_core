module Spree
  class Rate <  ActiveRecord::Base

    include Spree::DynamicAttribute

    def self.excluded_list
      ['variant_id', 'variant=']
    end

    belongs_to :variant, :class_name => 'Spree::Variant', :foreign_key => 'variant_id'
    has_many :option_values, :class_name => 'Spree::RateOptionValue', :foreign_key => 'rate_id', :dependent => :destroy

    # TODO: poner una restriccion para evitar solapamiento de fechas o al menos evitar que las
    # que se solapen tengan el mismo position

  end
end
