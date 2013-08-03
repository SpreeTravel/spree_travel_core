Deface::Override.new(
    :virtual_path => 'spree/products/show',
    :name => 'change_product_properties',
    :replace => "[data-hook='product_properties']",
    :partial => "spree/products/enhanced_properties"
)