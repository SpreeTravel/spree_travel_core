Deface::Override.new(:virtual_path => "spree/shared/_products",
                     :name => "change_product_index_partial",
                     :replace => "[data-hook='products_list_item']",
                     :partial => "spree/home/product_list_item",
                     :disabled => false
)

