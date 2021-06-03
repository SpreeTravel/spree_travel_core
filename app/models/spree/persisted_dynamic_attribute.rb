# frozen_string_literal: true

module Spree
  module PersistedDynamicAttribute
    include Spree::DynamicAttribute

    def persist_option_values(params)
      sanitize_option_types_and_values(params).each do |key, value|
        next if key == 'product_type'

        persist_option_value(Spree::OptionType.find_by(name: key), value)
      end
    end

    def persist_option_value(option_type, value)
      klass_option_value = find_existing_option_value(option_type)

      unless klass_option_value
        class_name = self.class.to_s
        klass_option_value = "#{class_name}OptionValue".constantize.new
        send("#{class_name.demodulize.downcase}_option_values") << klass_option_value
      end


      "Spree::#{option_type.attr_type.camelcase}OptionType".constantize
                                                           .save(klass_option_value, value, option_type)
    end

    def persisted_option_value(option_type, attrib = 'presentation')
      # option_type = Spree::OptionType.find_by(name: name)

      context_or_rate_option_value = find_existing_option_value(option_type)

      return if context_or_rate_option_value.nil?

      "Spree::#{option_type.attr_type.camelcase}OptionType".constantize.value(context_or_rate_option_value, attrib)
    end
  end
end
