# frozen_string_literal: true

# This methods are used when the context is temporal, meaning, when a search is made.
# This context will not persist
module Spree
  module TemporalDynamicAttribute
    def set_temporal_option_values(params)
      params.each do |key, value|
        set_temporal_option_value(key, value)
      end
    end

    def set_temporal_option_value(option_type, value)
      @temporal[option_type.to_s] = value
    end

    def get_temporal_option_value(option_type)
      @temporal[option_type.to_s]
    end
  end
end
