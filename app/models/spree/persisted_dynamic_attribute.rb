# frozen_string_literal: true

# This methods are used when the context will persist in the database.
# When a travel product is added to the cart, the context will persist.
module Spree
  module PersistedDynamicAttribute
    def persist_option_values(params)
      params.each do |key, value|
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

      klass_option_value.persist(option_type, value)
    end

    def persisted_option_value(option_type, attr = 'presentation')
      klass_option_value = find_existing_option_value(option_type)

      return '' if klass_option_value.nil?

      klass_option_value.persisted(option_type, attr)
    end
  end
end
