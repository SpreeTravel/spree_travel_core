Deface::Override.new(
    :virtual_path => 'spree/products/show',
    :name => 'add_links_to_product',
    :insert_after => "[data-hook='product_points']",
    :partial => "spree/products/product_links"
)