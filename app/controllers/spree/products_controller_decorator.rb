module Spree
  ProductsController.class_eval do

    def get_ajax_price
      product = Spree::Product.find(params[:product_id])
      calculator_class = product.calculator.name.constantize
      context = Spree::Context.build_from_params(params)
      variant = Spree::Variant.variant_from_params(params)

      #The variant returns with a nil value if there is not one holding a value for
      #the product_type_variant_option_type that defines the product_type per_se
      if variant.nil?
        hash = { :variant => "none", :prices => "0.0" }
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
end
