module Spree
  ProductsController.class_eval do

    def get_ajax_price
      product = Spree::Product.find(params[:product_id])
      calculator_class = product.calculator.name.constantize
      prices = calculator_class.calculate_price(params).sort
      prices = [prices[0], ' ... ', prices[-1]] if prices.count > 1
      respond_to do |format|
        number = rand(3)
        sleep number
        format.json {render :text => prices.to_s }
      end
    end

  end
end
