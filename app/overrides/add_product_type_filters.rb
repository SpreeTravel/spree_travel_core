Deface::Override.new(
    :virtual_path => 'spree/admin/products/index',
    :name => 'add_product_type_filters',
    :insert_bottom => "[data-hook='admin_products_index_search']",
    :partial => 'spree/admin/products/product_type_filter',
    disabled: false
)
