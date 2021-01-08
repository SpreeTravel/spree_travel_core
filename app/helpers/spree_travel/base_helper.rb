module SpreeTravel
  module BaseHelper
    def display_travel_price(variant:)
      product_type_name = variant.product_type.name
      context = Spree::Context.build_from_params(params.merge!(product_type: product_type_name), temporal:true)
      # This function returns a hash with the price, we need to relate the rates with the Spree::Price
      variant.product.calculate_price(context, variant, temporal: true )
    end
  end
end