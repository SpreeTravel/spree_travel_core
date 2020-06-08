module Spree
  module PersistedDynamicAttribute

    include Spree::DynamicAttribute

    def set_persisted_option_values(params)
      option_types_and_values_from_params(params).each do |key, value|
        set_persisted_option_value(key, value)
      end
    end

    def set_persisted_option_value(option_type, value)
      option_type = get_option_type_object(option_type)
      ovr = nil

      ovr = self.find_existing_option_value(option_type) if option_type

      unless ovr
        ovr = "#{self.class.to_s}OptionValue".constantize.new
        self.option_values << ovr
      end

      if option_type
        if option_type.attr_type == 'selection' || option_type.attr_type == 'destination'
          ovr.option_value_id = value
        else
          ovr.option_value_id = option_type.option_values.first.id
          ovr.value = value
        end
      else
        # TODO: ver si hay que hacer un option_type especial para el "product_type"
        ovr.value = value
      end

      ovr.save
    end

    def get_persisted_option_value(option_type, attrib='presentation')
      ot = get_option_type_object(option_type)
      return if ot.nil?
      ovr = self.option_values.find {|ov| ov.option_value && ov.option_value.option_type_id == ot.id }
      if ovr
        if %w(selection destination).include?(ot.attr_type)
          ovr.option_value.send(attrib)
        else
          price_or_value(ovr)
        end
      end
    end

    def price_or_value(rate_option_value)
      if rate_option_value.option_value.option_type.preciable?
        # TODO sustitude USD by current_currency
        rate_option_value.price_in('USD')
                         .display_price_including_vat_for({tax_zone: Spree::Zone.default_tax}).money
      else
        rate_option_value.value
      end

    end

    def get_option_type_object(option_type)
      option_type = if option_type.is_a?(Integer)
                      Spree::OptionType.find(option_type)
                    else
                      Spree::OptionType.find_by_name(option_type)
                    end
      option_type
    end

  end
end
