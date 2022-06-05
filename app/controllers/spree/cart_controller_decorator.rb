module Spree::CartControllerDecorator

  def add_item
    variant = Spree::Variant.find(params[:variant_id])

    spree_authorize! :update, spree_current_order, order_token
    spree_authorize! :show, variant

    rate = Spree::Rate.find_by(id: params[:rate_id])

    context = Spree::Context.build_from_params(params_sanitize, temporal: false) if params['product_type']

    result = add_item_service.call(
        order: spree_current_order,
        variant: variant,
        rate: rate,
        context: context,
        price: params[:price],
        quantity: params[:quantity],
        options: params[:options]
    )

    render_order(result)
  end

  private

  def params_sanitize
    Spree::ParamsSanitize.new(klass: 'context', params: params).call
  end

end

# Spree::Api::V2::Storefront::CartController.prepend Spree::CartControllerDecorator