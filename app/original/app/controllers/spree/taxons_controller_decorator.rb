module Spree
  TaxonsController.class_eval do

    def show
      taxon = Taxon.find_by_permalink!(params[:id])
      return unless taxon

      if !taxon.permalink.start_with?('destinations')

        @popular_products = Spree::ProductGroup.find_by_name("popular_products").products.limit(5).with_default_inclusions rescue []
        recomended_params = params.clone
        recomended_params[:recomended] = true
        recomended_params[:limit] = 9
        @recomended_product = Spree::Config.searcher_class.new(recomended_params).retrieve_products

        searcher_class = Spree::Config.searcher_class
        new_params = params.merge(:taxon => taxon.id)
        @searcher = searcher_class.new(new_params)
        @products = @searcher.retrieve_products
        @total = @searcher.total_products
        @per_page = params[:items_per_page] || 10
        @order_by = params[:sort] || 'recomended_desc'

      end

      @taxon = taxon
      respond_with(taxon)

    end

  end
end


