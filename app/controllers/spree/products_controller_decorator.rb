module Spree
  ProductsController.class_eval do

    def get_ajax_price
      product = Spree::Product.find(params[:product_id])
      calculator_class = product.calculator.name.constantize
      prices = calculator_class.calculate_price(params).sort
      #TODO este método de calcular la variante se llama dos veces
      variant = calculator_class.calculate_variant(params)
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
