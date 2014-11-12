module Spree
  module Admin
    ProductsController.class_eval do
      after_action :after_save, only: :create

      def after_save
        @product.generate_variants
      end

    end
  end
end
