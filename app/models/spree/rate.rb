module Spree
  class Rate < ActiveRecord::Base
    belongs_to :variant, :class_name => 'Spree::Variant', :foreign_key => 'variant_id'
    has_many :option_values, :class_name => 'Spree::RateOptionValue', :foreign_key => 'rate_id', :dependent => :destroy

    def set_option_values(params)
      option_types = self.variant.product.rate_option_types
      params.each do |k, v|
        option_type = option_types.find {|ot| ot.name == k }
        set_option_value(option_type, v) if option_type
      end
    end

    def set_option_value(option_type, value)
      ot = get_option_type_object(option_type)
      ovr = self.option_values.find {|ov| ov.option_value.option_type_id == ot.id}
      unless ovr
        ovr = Spree::RateOptionValue.new
        ovr.rate_id = self.id
      end
      if ot.attr_type == 'selection'
        ovr.option_value_id = value
      else
        ovr.option_value_id = ot.option_values.first.id
        ovr.value = value
      end
      ovr.save
    end

    def method_missing(method_name, *args)
      method_name = method_name.to_s
      get_option_value(method_name, *args)
    rescue
      super
    end

    def get_option_value(option_type, attr='id')
      ot = get_option_type_object(option_type)
      ovr = self.option_values.find {|ov| ov.option_value.option_type_id == ot.id}
      (ot.attr_type == 'selection' ? ovr.option_value.send(attr) : ovr.value) if ovr
    end

    def get_option_type_object(option_type)
      if option_type.is_a?(String)
        option_type = Spree::OptionType.find_by_name(option_type)
      elsif option_type.is_a?(Integer)
        option_type = Spree::OptionType.find(option_type)
      end
      option_type
    end

    # TODO: poner una restriccion para evitar solapamiento de fechas o al menos evitar que las
    # que se solapen tengan el mismo position

  end
end
