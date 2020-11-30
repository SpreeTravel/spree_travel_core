module SpreeTravel
  module BaseHelper

    def display_travel_price(variant:)
      product_type_name = variant.product_type.name
      context = Spree::Context.build_from_params(params.merge!(product_type: product_type_name), temporal:true)
      # This function returns a hash with the price, we need to relate the rates with the Spree::Price
      variant.product.calculate_price(context, variant, temporal: true )
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
end


# module Spree
#   module BaseHelperDecorator
#
#     def display_travel_price(variant:)
#       product_type_name = variant.product_type.name
#       context = Spree::Context.build_from_params(params.merge!(product_type: product_type_name), temporal:true)
#       variant.product.calculate_price(context, product_or_variant, temporal: true )
#     end
#
#     def get_rate_price(rate, adults, children)
#       adults = adults.to_i
#       children = children.to_i
#       adults_hash = {1 => 'simple', 2 => 'double', 3 => 'triple'}
#       price = adults * rate.send(adults_hash[adults]).to_f
#       price += rate.first_child.to_f if children >= 1
#       price += rate.second_child.to_f if children == 2
#       price
#     end
#
#   end
# end
#
# Spree::BaseHelper.prepend Spree::BaseHelperDecorator
