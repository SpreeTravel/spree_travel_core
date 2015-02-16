module Spree
  ProductsController.class_eval do
    before_action :add_childrens_param, only: :show

    def add_childrens_param
      begin
        @childrens = @product.childrens || @product.variants
      rescue
        @childrens = @product.variants
      end
    end

    def get_ajax_price
      product = Spree::Product.find(params[:product_id])
      context = Spree::Context.build_from_params(params, :temporal => true)
      prices = product.calculate_price(context)
      Log.debug(prices.inspect)
      hash = { :product_id => params[:product_id], :prices => prices }

      respond_to do |format|
        number = rand(3)
        sleep number
        format.json {render :json => hash }
      end
    end

  end
end
