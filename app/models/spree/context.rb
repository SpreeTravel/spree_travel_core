module Spree
  class Context < ActiveRecord::Base

    include PersistedDynamicAttribute
    include TemporalDynamicAttribute

    belongs_to :line_item, :class_name => 'Spree::LineItem', :foreign_key => 'line_item_id'
    has_many :option_values, :class_name => 'Spree::ContextOptionValue', :foreign_key => 'context_id', :dependent => :destroy

    def initialize_variables
      @temporal = {}
    end

    def get_temporal
      @temporal
    end

    def self.build_from_params(params, options = {})
      raise Exception.new("You must be explicit about temporal or not") if options[:temporal].nil?
      context = Spree::Context.new
      context.initialize_variables
      context_params = context.option_types_and_values_from_params(params)
      if options[:temporal]
        context.set_temporal_option_values(context_params)
      else
        context.set_persisted_option_values(context_params)
      end
      context.save
      return context
    end

    def product_type(options = {:temporal => true})
      get_mixed_option_value(:product_type, options)
    end

    def start_date(options = {:temporal => true})
      get_mixed_option_value(:start_date, options)
    end

    def end_date(options = {:temporal => true})
      get_mixed_option_value(:end_date, options)
    end

    def plan(options = {:temporal => true})
      get_mixed_option_value(:plan, options)
    end

    def adult(options = {:temporal => true})
      get_mixed_option_value(:adult, options)
    end

    def child(options = {:temporal => true})
      get_mixed_option_value(:child, options)
    end

    def room(options = {:temporal => true})
      get_mixed_option_value(:room, options)
    end

    def departure_date(options = {:temporal => true})
      get_mixed_option_value(:departure_date, options)
    end
  end
end
