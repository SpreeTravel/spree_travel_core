Spree::HomeController.class_eval do

    def index

      if params[:redirect_controller]
        params[:controller] = params[:redirect_controller]
        params[:action] = params[:redirect_action]
        params[:id] = params[:redirect_product] if params[:controller] == 'products'
        redirect_to params
        return
      end

      @popular_products = Spree::ProductGroup.find_by_name("popular_products").products.limit(5).includes(:translations) rescue []

      if params[:keywords]
        @searcher = Spree::Config.searcher_class.new(params)
        @products = @searcher.retrieve_products
        @total = @searcher.total_products
        @per_page = params[:items_per_page] || 10
        @order_by = params[:sort] || nil
        page = "spree/home/search_result"
      else
        things_to_do = Spree::Taxon.find_by_permalink('things-to-do')
        @things = Spree::Product.in_taxon(things_to_do).order('RAND()').includes(:translations).limit(3)
        @destinations = Spree::Product.where("permalink like 'destinations-%'").available.order('RAND()').limit(12).includes(:translations)
        params[:recomended] = true
        params[:limit] = 9
        @searcher = Spree::Config.searcher_class.new(params)
        @recomended_product = @searcher.retrieve_products
        page = "spree/home/page"
      end

      render page

    end

  end

