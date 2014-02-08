module Spree
  ProductsController.class_eval do

    def get_ajax_price
      product = Spree::Product.find(params[:product_id])
      prices = product.calculator_class.calculate_price(params).to_s
      # TODO: llegan dos variantes en vez de una, la lista de precios no se
      # muestra bien en la vista
      puts '-------------------------------> ' + prices
      respond_to do |format|
        number = rand(4)
        sleep number
        format.json {render :text => prices }
      end
    end

  end
end
