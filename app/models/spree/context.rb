module Spree
  class Context < ActiveRecord::Base

    include Spree::DynamicAttribute

    belongs_to :line_item, :class_name => 'Spree::LineItem', :foreign_key => 'line_item_id'
    has_many :option_values, :class_name => 'Spree::ContextOptionValue', :foreign_key => 'context_id', :dependent => :destroy

    def initialize_variables
      @temporal = {}
    end

    def get_temporal
      @temporal
    end

    def self.build_from_params(params)
      context_params = {}
      prefix = "#{params[:product_type]}_"
      params.each do |k, v|
      	if k.starts_with?(prefix)
      	  context_params[k.gsub(prefix, '')] = v
      	else
      	  context_params[k] = v
      	end
      end
      context = Spree::Context.new
      context.initialize_variables
      context.set_option_values(context_params, :temporal => true)
      return context
    end

    def start_date
      get_temporal_option_value(:start_date)
    end

    def end_date
      get_temporal_option_value(:end_date)
    end

    def plan
      get_temporal_option_value(:plan)
    end

    def adult
      get_temporal_option_value(:adult)
    end

    def child
      get_temporal_option_value(:child)
    end

  end
end
