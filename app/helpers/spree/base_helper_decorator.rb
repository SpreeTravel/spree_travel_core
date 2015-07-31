Spree::BaseHelper.class_eval do

    # def display_price(product_or_variant)
    #   product_or_variant.price_in(current_currency).display_price.to_html
    # end
    #
    #TODO hay que tener en cuenta aqui la tasa de cambio como está en el método de arriba
    def display_combination_price(product)
      context = Spree::Context.build_from_params(params, :temporal => true)
      prices = product.calculate_price(context, :temporal => true )
      prices
    end

end
