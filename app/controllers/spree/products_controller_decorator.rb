module Spree::ProductsControllerDecorator
  def self.prepended(base)
    base.helper 'spree_travel/base'
    base.before_action :add_childrens_param, only: :show
  end

  def show
    if @product.product_type.present? && params[:product_type].nil?
      flash[:error] = "You don't have access to this product"
      redirect_to root_path
    else
      @variants = @product.variants_including_master.
          spree_base_scopes.
          active(current_currency).
          includes([:option_values, :images])
      @product_properties = @product.product_properties.includes(:property)
      @taxon = params[:taxon_id].present? ? Spree::Taxon.find(params[:taxon_id]) : @product.taxons.first
      redirect_if_legacy_path
    end

  end
end


Spree::ProductsController.prepend Spree::ProductsControllerDecorator