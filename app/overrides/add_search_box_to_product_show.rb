Deface::Override.new(
    :virtual_path => 'spree/products/show',
    :name => 'add_search_box_to_products_show',
    :insert_after => "[data-hook='product_properties']",
    :partial => "spree/shared/search_box",
    :disabled => true
)

# Let the users put the search box where then want, we will only put it in the homepage.