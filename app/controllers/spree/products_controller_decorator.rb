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
      if product.product_type.id != Spree::ProductType.find_by_name(params[:product_type]).id
        hash = { :product_id => params[:product_id], :variant => "none", :prices => "0.0" }
        respond_to do |format|
          number = rand(3)
          sleep number
          format.json {render :json => hash }
        end
        return
      end
      calculator_class = product.calculator.name.constantize
      context = Spree::Context.build_from_params(params, :temporal => true)
      puts context.inspect
      variant = Spree::Variant.variant_from_params(params)
      puts variant.inspect

      #The variant returns with a nil value if there is not one holding a value for
      #the product_type_variant_option_type that defines the product_type per_se
      if variant.nil?
        hash = { :product_id => params[:product_id], :variant => "none", :prices => "0.0" }
        respond_to do |format|
          number = rand(3)
          sleep number
          format.json {render :json => hash }
        end
      else
        prices = calculator_class.calculate_price(context, variant).sort
        if prices.count > 1
          prices_str = "#{Spree.t(:starting)} #{prices[0]}"
        else
          # TODO: poner la forma correcta de currency llamando a Spree::Money.new....
          prices_str = "$ %.2f" % prices[0]
        end
        hash = { :product_id => params[:product_id], :variant => variant.id, :prices => prices_str }

        respond_to do |format|
          number = rand(3)
          sleep number
          format.json {render :json => hash }
        end
      end
    end

  end
end
