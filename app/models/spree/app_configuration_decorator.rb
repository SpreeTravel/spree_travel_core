Spree::AppConfiguration.class_eval do
  preference :use_cart, :boolean, default: true #true if you want to have a cart or false will directly to the checkout process with one product only

  # searcher_class allows spree extension writers to provide their own Search class
  def searcher_class
    @searcher_class ||= Spree::Core::Search::SpreeTravelBase
  end

end