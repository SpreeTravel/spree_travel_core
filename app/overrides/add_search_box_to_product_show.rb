Deface::Override.new(
    :virtual_path => 'spree/products/show',
    :name => 'add_search_box_to_product_show',
    :insert_before => "[data-hook='product_right_part']",
    :partial => "spree/shared/search_box_product",
    :disabled => false
)
