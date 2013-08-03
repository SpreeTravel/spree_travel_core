Deface::Override.new(:virtual_path => "spree/products/show",
                     :name => "line_email_link_on_products",
                     :remove => "p.email_to_friend", 
		     :sequence => {:after => "converted_product_description_351026984"},
         :disabled => true
)

Deface::Override.new(:virtual_path => "spree/products/_taxons",
                     :name => "line_email_link_on_products",
                     :insert_top => "#taxon-crumbs[data-hook]",
                     :partial => "spree/shared/email",
                      :disabled => true
)


