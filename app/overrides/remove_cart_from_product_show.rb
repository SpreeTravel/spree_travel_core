Deface::Override.new(
    :virtual_path => 'spree/products/show',
    :name => 'remove_cart_form_product_show',
    :remove => "[data-hook='cart_form']"
)