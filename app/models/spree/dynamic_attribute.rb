# frozen_string_literal: true

module Spree
  module DynamicAttribute
    # This method validate that the params passed are valid Context or Rate
    # option types that exist as a relation of the ProductType
    # It will output only the valid ones removing the non existing from the return hash
    def sanitize_option_types_and_values(params)
      prefix = params['product_type']
      if prefix
        product_type = Spree::ProductType.find_by(name: prefix)
        attr_option_types = self.class.to_s.split('::').last.downcase + '_option_types'
        option_types_objects = product_type.send(attr_option_types)
        option_types = option_types_objects.map(&:name)
        # TODO: this is a path we have to fix to have the MEALPLAN as part of the context but not in the searcher
        option_types << 'plan' if prefix == 'hotel'
      else
        option_types = %i[start_date end_date adult child]
      end
      hash = {}

      params.each do |key, value|
        name = key
        option_type = option_types.find do |ot|
          name = key[prefix.length + 1..-1] if prefix && key.index(prefix) == 0
          (name == ot)
        end
        hash[name.to_s] = value if option_type
      end
      hash['product_type'] = prefix
      hash
    end

    def get_mixed_option_value(option_type, options = { temporal: true })
      return get_temporal_option_value(option_type) if options[:temporal]

      persisted_option_value(option_type)
    end
  end
end
