module Spree
  ProductsController.class_eval do

    def get_ajax_price
      product = Spree::Product.find(params[:product_id])
      string = product.price
      respond_to do |format|
        number = rand(4)
        sleep number
        format.json {render :text => string }
      end
    end

  end
end
