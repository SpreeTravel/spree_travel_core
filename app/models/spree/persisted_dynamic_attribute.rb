# frozen_string_literal: true

module Spree
  module PersistedDynamicAttribute
    include Spree::DynamicAttribute

    def persist_option_values(params)
      sanitize_option_types_and_values(params).each do |key, value|
        next if key == 'product_type'

        persist_option_value(key, value)
      end
    end

    def persist_option_value(option_type, value)
      option_type, context_or_rate_option_value = find_option_value(option_type)

      return if option_type.nil?

      unless context_or_rate_option_value
        class_name = self.class.to_s
        context_or_rate_option_value = "#{class_name}OptionValue".constantize.new
        self.send("#{class_name.demodulize.downcase}_option_values") << context_or_rate_option_value
      end

      "Spree::#{option_type.attr_type.camelcase}OptionType".constantize.save(context_or_rate_option_value, value, option_type)
    end

    def get_persisted_option_value(option_type, attrib = 'presentation')
      option_type, context_or_rate_option_value = find_option_value(option_type)

      return if option_type.nil? || context_or_rate_option_value.nil?

      "Spree::#{option_type.attr_type.camelcase}OptionType".constantize.value(context_or_rate_option_value)
    end

    def get_option_type_object(option_type)
      return Spree::OptionType.find(option_type) if option_type.is_a?(Integer)

      Spree::OptionType.find_by_name(option_type)
    end

    def find_option_value(option_type)
      option_type = get_option_type_object(option_type)

      [option_type, find_existing_option_value(option_type)]
    end
  end
end
