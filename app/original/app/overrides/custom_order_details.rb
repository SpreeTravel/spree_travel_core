Deface::Override.new(:virtual_path => "spree/orders/_line_item",
                     :name => "custom_order_details",
                     :replace => "#order[data-hook]",
                     :partial => "spree/shared/order_details"
)

Deface::Override.new(:virtual_path => "spree/orders/_line_item",
                     :name => "remove_checkout_html_tag",
                     :replace => "[data-hook='cart_item_description']",
                     :partial => "spree/orders/checkout_description",
                     :disabled => true
)

Deface::Override.new(:virtual_path => "spree/orders/_line_item",
                     :name => "converted_cart_item_description_722158932",
                     :insert_bottom => "[data-hook='cart_item_description']",
                     :partial => "spree/orders/cart_item_description",
                     :sequence => {:after => "remove_checkout_html_tag"},
                     :disabled => true
)

Deface::Override.new(:virtual_path => "spree/orders/_line_item",
                     :name => "add_customization_after_description",
                     :insert_bottom => "p#cart-item-product-description",
                     :partial => "spree/orders/cart_item_description",
                     :sequence => {:after => "remove_checkout_html_tag"},
                     :disabled => true
)

Deface::Override.new(:virtual_path => "spree/shared/_order_details",
                     :name => "add_extra_order_details_line_item_description",
                     :insert_bottom => "[data-hook='order_item_description']",
                     :partial => "spree/shared/extra_order_details_line_item_description",
                     :disabled => true
)

Deface::Override.new(:virtual_path => "spree/admin/shared/_order_details",
                     :name => "add_extra_order_details_line_item_description_admin",
                     :insert_bottom => "[data-hook='order_details_line_item_row'] td:first",
                     :partial => "spree/shared/extra_order_details_line_item_description",
                     :disabled => true
)