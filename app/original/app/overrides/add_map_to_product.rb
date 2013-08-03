Deface::Override.new(
    :virtual_path => 'spree/products/show',
    :name => 'add_map_to_product',
    :insert_after => "[data-hook='product_map']",
    :partial => "spree/products/product_map",
    :disabled => false
)
