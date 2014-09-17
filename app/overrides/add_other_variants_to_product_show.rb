Deface::Override.new(
    :virtual_path => 'spree/products/show',
    :name => 'add_other_variants_to_product_show',
    :insert_after => "[data-hook='product_right_part_wrap']",
    :partial => "spree/products/other_variants"
)