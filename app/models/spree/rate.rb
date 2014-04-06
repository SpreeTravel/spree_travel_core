module Spree
  class Rate < ActiveRecord::Base
    belongs_to :variant, :class_name => 'Spree::Variant', :foreign_key => 'variant_id'
    has_many :option_values, :class_name => 'Spree::RateOptionValue', :foreign_key => 'rate_id'
    
    def set_option_values(params)
      option_types = self.variant.product.rate_option_types
      params.each do |k, v|
        option_type = option_types.find {|ot| ot.name == k }
        set_option_value(option_type, v) if option_type
      end
    end
    
    def set_option_value(option_type, value)
      ovr = self.option_values.find {|ov| ov.option_value.option_type_id == option_type.id}
      unless ovr
        ovr = Spree::RateOptionValue.new
        ovr.rate_id = self.id
      end
      if option_type.attr_type == 'selection'
        ovr.option_value_id = value
      else
        ovr.option_value_id = option_type.option_values.first.id
        ovr.value = value
      end
      ovr.save
    end

    def get_option_value(option_type, attr='id')
      ovr = self.option_values.find {|ov| ov.option_value.option_type_id == option_type.id}
      (option_type.attr_type == 'selection' ? ovr.option_value.send(attr) : ovr.value) if ovr
    end
    
    # TODO: poner una restriccion para evitar solapamiento de fechas o al menos evitar que las
    # que se solapen tengan el mismo position

  end
end
