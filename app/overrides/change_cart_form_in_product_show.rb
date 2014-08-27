Deface::Override.new(
    :virtual_path => 'spree/products/show',
    :name => 'change_cart_form_in_product_show',
    :replace => "[data-hook='cart_form']",
    :partial => "spree/products/new_cart_form",
    :disabled => true
)
