Deface::Override.new(:virtual_path => "spree/orders/_line_item",
                         :name => "converted_cart_item_description_722158932",
                         :insert_bottom => "[data-hook='cart_item_description']",
                         :partial => "spree/orders/cart_item_description",
                         :sequence => {:after => "remove_checkout_html_tag"},
                         :disable => true
)
