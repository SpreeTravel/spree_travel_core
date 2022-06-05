module Spree::ProductsControllerDecorator

  def index
    @searcher = build_searcher(params.merge(include_images: true))
    @products = @searcher.retrieve_products
    @products = @products.includes(:possible_promotions) if @products.respond_to?(:includes)

    @context = Spree::Context.build_from_params(params_sanitize, temporal: true) if params['product_type']

    @taxonomies = load_taxonomies
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
      @context = Spree::Context.build_from_params(params_sanitize, temporal: true) if @product.product_type.present?
      @taxon = params[:taxon_id].present? ? Spree::Taxon.find(params[:taxon_id]) : @product.taxons.first
      redirect_if_legacy_path
    end
  end

  private

  def params_sanitize
    Spree::ParamsSanitize.new(klass: 'context', params: params).call
  end
end


# Spree::ProductsController.prepend Spree::ProductsControllerDecorator