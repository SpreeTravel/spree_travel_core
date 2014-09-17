module Spree
  module Admin
    ProductsController.class_eval do
      after_action :after_save, only: :create

      #NOTE: Esto asume que un solo option_type define a la variante
      def after_save
        @product.variants.each do |v|
          puts v.price
        end
        product_type = @product.product_type
        product_type.variant_option_types.each do |ot|
          ot.option_values.each do |ov|
            variant = Spree::Variant.new(sku: ot.name + ov.presentation.downcase, price: 0)
            variant.option_values << ov
            @product.variants << variant
          end
        end
      end
    end
  end
end