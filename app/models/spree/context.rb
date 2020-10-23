# frozen_string_literal: true

module Spree
  class Context < Spree::Base
    include PersistedDynamicAttribute
    include TemporalDynamicAttribute

    has_many :line_items, class_name: 'Spree::LineItem',
                          foreign_key: 'context_id'
    has_many :option_values, class_name: 'Spree::ContextOptionValue',
                             foreign_key: 'context_id',
                             dependent: :destroy

    def initialize_variables
      @temporal = {}
    end

    def get_temporal
      @temporal
    end

    def self.build_from_params(params, options = {})
      return nil if params[:product_type].nil?
      raise StandardError, 'You must be explicit about temporal or not' if options[:temporal].nil?

      context = if !options[:line_item_id].nil?
                  Spree::LineItem.find(options[:line_item_id]).context
                else
                  Spree::Context.new
                end

      context.initialize_variables
      if options[:temporal]
        context.set_temporal_option_values(params)
      else
        context.set_persisted_option_values(params)
        context.save
      end
      context
    end

    %i[
      product_type start_date end_date plan adult child
      cabin_count departure_date category pickup_destination
      return_destination pickup_date return_date
    ].each do |method|
      define_method method do |temporal=nil|
        get_mixed_option_value(method, temporal)
      end
    end

    # this is for the amount of rooms
    def room_count(options = { temporal: true })
      get_mixed_option_value(:room_count, options)
    end

    # this is for the room type (Sweet, Junio Sweet, etc.....)
    def room(options = { temporal: true })
      get_mixed_option_value(:room, options)
    end

    def find_existing_option_value(option_type)
      option_values.includes(option_value: :option_type)
                   .find { |ov| ov.option_value&.option_type_id == option_type.id }
    end
  end
end
