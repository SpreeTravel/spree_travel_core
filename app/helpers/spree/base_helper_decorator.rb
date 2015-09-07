Spree::BaseHelper.class_eval do

    # def display_price(product_or_variant)
    #   product_or_variant.price_in(current_currency).display_price.to_html
    # end
    #
    #TODO hay que tener en cuenta aqui la tasa de cambio como está en el método de arriba
    def display_the_price(variant)
      context = Spree::Context.build_from_params(params.merge!(product_type: variant.product.product_type.name), :temporal => true)
      variant.calculate_price(context, :temporal => true )
    end

    def get_rate_price(rate, adults, children)
      adults = adults.to_i
      children = children.to_i
      adults_hash = {1 => 'simple', 2 => 'double', 3 => 'triple'}
      price = adults * rate.send(adults_hash[adults]).to_f
      price += rate.first_child.to_f if children >= 1
      price += rate.second_child.to_f if children == 2
      price
    end

end
