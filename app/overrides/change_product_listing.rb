Deface::Override.new(:virtual_path => "spree/shared/_products",
                     :name => "change_product_listing",
                     :replace => "#products",
                     :partial => 'spree/shared/product_listing',
                     :disabled => false
)

