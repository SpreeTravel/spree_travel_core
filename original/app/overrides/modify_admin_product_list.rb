Deface::Override.new(
    :virtual_path => 'spree/admin/products/index',
    :name => 'modify_admin_product_list_header',
    :replace => "[data-hook='admin_products_index_headers']",
    :partial => "spree/admin/products/product_list_header"
)

Deface::Override.new(
    :virtual_path => 'spree/admin/products/index',
    :name => 'modify_admin_product_list_rows',
    :replace => "[data-hook='admin_products_index_rows']",
    :partial => "spree/admin/products/product_list_row"
)

