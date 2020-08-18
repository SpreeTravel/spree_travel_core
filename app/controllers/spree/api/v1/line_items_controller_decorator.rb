module Spree::Api::V1::LineItemsControllerDecorator

  def line_items_attributes
    { line_items_attributes: {
        id: params[:id],
        quantity: params[:line_item][:quantity],
        options: line_item_params[:options] || {},
        context: params[:line_item][:context]
    } }
  end

  def line_item_params
    params.require(:line_item).permit(
        :quantity,
        :variant_id,
        options: line_item_options,
        context: params[:line_item][:context].as_json
    )
  end

end

Spree::Api::V1::LineItemsController.prepend LineItemsControllerDecorator