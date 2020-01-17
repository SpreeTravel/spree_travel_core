module Spree::ProductsControllerDecorator
  def self.prepended(base)
    base.before_action :add_childrens_param, only: :show
  end

    def add_childrens_param
      begin
        @childrens = @product.childrens || @product.variants
      rescue
        @childrens = @product.variants
      end
    end
end


Spree::ProductsController.prepend Spree::ProductsControllerDecorator