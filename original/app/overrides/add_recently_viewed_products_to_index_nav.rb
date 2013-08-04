Deface::Override.new(:virtual_path => "spree/shared/_taxonomies",
		     :insert_bottom => "nav#taxonomies",
		     :partial => "spree/shared/recently_viewed_products",
		     :name => "add_recently_viewed_products_to_index_nav",
         :disabled => false
)
