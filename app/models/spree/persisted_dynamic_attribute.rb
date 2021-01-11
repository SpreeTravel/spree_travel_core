# frozen_string_literal: true

module Spree
  module PersistedDynamicAttribute
    include Spree::DynamicAttribute

    def set_persisted_option_values(params)
      sanitize_option_types_and_values(params).each do |key, value|
        next if key == 'product_type'

        set_persisted_option_value(key, value)
      end
    end

    def set_persisted_option_value(option_type, value)
      option_type, context_or_rate_option_value = find_option_value(option_type)

      return if option_type.nil?

      unless context_or_rate_option_value
        class_name = self.class.to_s
        context_or_rate_option_value = "#{class_name}OptionValue".constantize.new
        self.send("#{class_name.demodulize.downcase}_option_values") << context_or_rate_option_value
      end

      # TODO Create a class to abstract the way each option value sets its value
      if selection_or_destination?(option_type)
        context_or_rate_option_value.option_value_id = value
      elsif preciable?(option_type)
        context_or_rate_option_value.price = value.to_i
      else
        context_or_rate_option_value.option_value_id = option_type.option_values.first.id
        context_or_rate_option_value.value = value
      end
      context_or_rate_option_value.save
    end

    def get_persisted_option_value(option_type, attrib = 'presentation')
      option_type, context_or_rate_option_value = find_option_value(option_type)

      return if option_type.nil? || context_or_rate_option_value.nil?

      price_or_value(context_or_rate_option_value, option_type, attrib)
    end

    def price_or_value(context_or_rate_option_value, option_type, attrib)
      # TODO Create a class to abstract the way each option value show its value
      if preciable?(option_type)
        # TODO: sustitude USD by current_currency
        context_or_rate_option_value.price_in('USD')
                                    .display_price_including_vat_for({tax_zone: Spree::Zone.default_tax})
                                    .money
      elsif selection_or_destination?(context_or_rate_option_value.option_value.option_type)
        context_or_rate_option_value.option_value.send(attrib)
      else
        context_or_rate_option_value.value
      end
    end

    def get_option_type_object(option_type)
      Spree::OptionType.find(option_type) if option_type.is_a?(Integer)

      Spree::OptionType.find_by_name(option_type)
    end

    def find_option_value(option_type)
      option_type = get_option_type_object(option_type)

      [option_type, find_existing_option_value(option_type)]
    end

    def selection_or_destination?(option_type)
      %w(selection destination).include?(option_type.attr_type)
    end

    def preciable?(option_type)
      option_type.preciable
    end
  end
end
