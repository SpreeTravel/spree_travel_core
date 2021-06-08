# frozen_string_literal: true

module Spree
  class Context < Spree::Base
    include PersistedDynamicAttribute
    include TemporalDynamicAttribute

    has_many :line_items, class_name: 'Spree::LineItem',
                          foreign_key: 'context_id'
    has_many :context_option_values, class_name: 'Spree::ContextOptionValue',
                                     foreign_key: 'context_id',
                                     dependent: :destroy

    def initialize_variables
      @temporal = {}
    end

    attr_reader :temporal

    class << self
      def build_from_params(params, options = {})
        raise StandardError, 'You must be explicit about temporal or not' if options[:temporal].nil?

        context = fetch_context(options)

        context.initialize_variables

        temporal_or_persisted(context, options, params)

        context
      end

      private

      def temporal_or_persisted(context, options, params)
        return context.set_temporal_option_values(params) if options[:temporal]

        context.persist_option_values(params)
        context.save
      end

      def fetch_context(options)
        return Spree::Context.new if options[:line_item_id].nil?

        Spree::LineItem.find(options[:line_item_id]).context
      end
    end

    def find_existing_option_value(option_type)
      context_option_values.includes(option_value: :option_type)
                           .find { |cov| cov.option_value&.option_type_id == option_type.id }
    end
  end
end
