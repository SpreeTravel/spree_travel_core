module Spree
  module Admin
    ProductsController.class_eval do
      after_action :after_save, only: :create

      #NOTE: Esto asume que un solo option_type define a la variante
      def after_save
        @product.generate_variants
      end
    end
  end
end
