Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "remove_review_page_from_index",
                     :remove => "aside#sidebar div#reviews",
		     :sequence => {:after => "review_sidebar"}
)
