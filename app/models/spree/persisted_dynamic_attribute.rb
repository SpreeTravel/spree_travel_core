module Spree
  module PersistedDynamicAttribute

    def set_persisted_option_values(params)
      option_types_and_values_from_params(params).each do |key, value|
        set_persisted_option_values(key, value)
      end
    end

    def set_persisted_option_value(option_type, value)
      ot = get_option_type_object(option_type)
      ovr = self.option_values.find {|ov| ov.option_value.option_type_id == ot.id}
      unless ovr
        ovr = "#{self.class.to_s}OptionValue".constantize.new
        self.option_values << ovr
      end
      if ot.attr_type == 'selection'
        ovr.option_value_id = value
      else
        ovr.option_value_id = ot.option_values.first.id
        ovr.value = value
      end
      ovr.save
    end

    def get_persisted_option_value(option_type, attrib='id')
      ot = get_option_type_object(option_type)
      ovr = self.option_values.find {|ov| ov.option_value && ov.option_value.option_type_id == ot.id }
      (ot.attr_type == 'selection' ? ovr.option_value.send(attrib) : ovr.value) if ovr
    end

    def get_option_type_object(option_type)
      if option_type.is_a?(Symbol)
        option_type = Spree::OptionType.find_by_name(option_type)
      elsif option_type.is_a?(String)
        option_type = Spree::OptionType.find_by_name(option_type)
      elsif option_type.is_a?(Integer)
        option_type = Spree::OptionType.find(option_type)
      end
      option_type
    end

  end
end
