module Spree
  module Admin
    ProductsController.class_eval do
      after_action :after_save, only: :create

      def after_save
        @product.generate_variants
      end

      def delete_rates
        puts params[:rates]
        flash[:success] = t(:successfully_deleted_rates)
        respond_to do |format|
          format.js
        end
      end
    end
  end
end
