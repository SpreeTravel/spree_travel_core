module Spree
  class Context < ActiveRecord::Base

	include Spree::DynamicAttribute

    belongs_to :line_item, :class_name => 'Spree::LineItem', :foreign_key => 'line_item_id'
    has_many :option_values, :class_name => 'Spree::ContextOptionValue', :foreign_key => 'context_id', :dependent => :destroy

    # TODO: hacer este metodo para construir un objecto contexto a partir de params
    def self.build_from_params(params)

      context_params = {}
      prefix = "#{params[:product_type]}_"
      context = self.new
      params.each do |k, v|
      	if k.starts_with?( prefix )
      	  context_params[k.gsub(prefix, '') ] = v
      	else
      	  context_params[k] = v
      	end
      end
      context.set_option_values(context_params)

      return context

    end

  end
end
