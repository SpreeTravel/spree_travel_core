Deface::Override.new(:virtual_path => "spree/taxons/showo",
                     :name => "change_product_index_partial",
                     :replace => "[data-hook='product_list_item']",
                     :partial => "spree/shared/product_list_item",
                     :disabled => false
)

