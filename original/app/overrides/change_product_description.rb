Deface::Override.new(
    :virtual_path => 'spree/products/show',
    :name => 'change_product_description',
    :replace => "[data-hook='product_description'], #product-description[data-hook]",
    :partial => "spree/products/new_description"
)