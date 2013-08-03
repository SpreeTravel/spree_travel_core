Deface::Override.new(:virtual_path => "spree/shared/_taxonomies",
		     :name => "add_recently_viewed_to_index_nav",
		     :insert_bottom => "#taxonomies[data-hook]",
		     :partial => "spree/shared/recently_viewed",
         :disabled => false
)
