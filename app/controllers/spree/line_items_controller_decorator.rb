# frozen_string_literal: true

module Spree
  module LineItemsControllerDecorator
    def line_items_attributes
      { line_items_attributes: {
        id: params[:id],
        quantity: params[:line_item][:quantity],
        context_attributes: context_params_sanitize,
        options: params[:options] || {}
      } }
    end

    def line_item_params
      params.require(:line_item).permit(
        :quantity,
        :variant_id,
        :context,
        options: line_item_options
      )
    end

    private

    def context_params_sanitize
      Spree::ParamsSanitize.new(klass: 'context',
                                params: params.dig(:line_item, :context)).call
    end
  end
end

# Spree::Api::V1::LineItemsController.prepend Spree::LineItemsControllerDecorator
