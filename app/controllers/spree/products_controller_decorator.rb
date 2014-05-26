module Spree
  ProductsController.class_eval do

    def get_ajax_price
      product = Spree::Product.find(params[:product_id])
      calculator_class = product.calculator.name.constantize

      context = Spree::Context.build_from_params(params)

      variant = Spree::Variant.variant_from_params(params)
      prices = calculator_class.calculate_price(context, variant).sort

      if prices.count > 1
        prices_str = "#{prices[0]} ... #{prices[-1]}"
      else
        prices_str = prices[0].to_s
      end
      hash = { :variant => variant.id, :prices => prices_str }
      respond_to do |format|
        number = rand(3)
        sleep number
        format.json {render :json => hash }
      end
    end

  end
end
