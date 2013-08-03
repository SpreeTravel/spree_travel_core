Deface::Override.new(:virtual_path => "spree/products/_taxons",
                     :name => "line_recently_viewed_in_product_view",
                     :insert_bottom => "#taxon-crumbs[data-hook]",
                     :partial => "spree/shared/recently_viewed_products")

Deface::Override.new(:virtual_path => "spree/products/show",
                     :name => "line_recently_viewed_in_product_view",
                     :remove => "#recently_viewed[data-hook]", 
		     :sequence => {:after => "add_recently_viewed_products_to_products_show"})
