module Spree
  module Admin
    class RatesController < ResourceController

      before_filter :load_product

      def load_product
        @product = Spree::Product.find_by_permalink(params[:product_id])
      end
      
      def collection_url
        admin_product_rates_path
      end
      
      def edit_object_url(rate)
        edit_admin_product_rate_path(:product_id => rate.variant.product.permalink, :id => rate.id)
      end
      
      def object_url(rate)
        admin_product_rate_path(:product_id => rate.variant.product.permalink, :id => rate.id)
      end

    end
  end
end
