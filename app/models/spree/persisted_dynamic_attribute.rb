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
        context_or_rate_option_value = "#{self.class.to_s}OptionValue".constantize.new
        self.option_values << context_or_rate_option_value
      end

      if selection_or_destination?(option_type)
        context_or_rate_option_value.option_value_id = value
      else
        context_or_rate_option_value.option_value_id = option_type.option_values.first.id
        context_or_rate_option_value.value = value
      end

      context_or_rate_option_value.save
    end

    def get_persisted_option_value(option_type, attrib = 'presentation')
      option_type, context_or_rate_option_value = find_option_value(option_type)

      return if option_type.nil?

      context_or_rate_option_value.option_value.send(attrib) if selection_or_destination?(option_type)

      price_or_value(context_or_rate_option_value)
    end

    def price_or_value(rate_option_value)
      if rate_option_value.option_value.option_type.preciable?
        # TODO: sustitude USD by current_currency
        rate_option_value.price_in('USD')
                         .display_price_including_vat_for({tax_zone: Spree::Zone.default_tax}).money
      else
        rate_option_value.value
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
  end
end
