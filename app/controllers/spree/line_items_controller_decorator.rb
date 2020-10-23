# frozen_string_literal: true

module Spree
  module LineItemsControllerDecorator
    def line_items_attributes
      { line_items_attributes: {
        id: params[:id],
        quantity: params[:line_item][:quantity],
        context_attributes: params[:line_item][:context].as_json,
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
  end
end

Spree::Api::V1::LineItemsController.prepend Spree::LineItemsControllerDecorator
