module Spree::Api::V1::LineItemsControllerDecorator

  def update
    @line_item = find_line_item
    # tthis contents i think does not exist no more....review
    if @order.contents.update_cart(line_items_attributes)
      @line_item.copy_price
      @line_item.save!
      @line_item.reload
      respond_with(@line_item, default_template: :show)
    else
      invalid_resource!(@line_item)
    end
  end

  def line_items_attributes
    {line_items_attributes: {
        id: params[:id],
        quantity: params[:line_item][:quantity],
        options: line_item_params[:options] || {},
        context: params[:line_item][:context]
    }}
  end

  def line_item_params
    params.require(:line_item).permit(
        :quantity,
        :variant_id,
        options: line_item_options,
        context: params[:line_item][:context]
    )
  end

end

Spree::Api::V1::LineItemsController.prepend Spree::Api::V1::LineItemsControllerDecorator