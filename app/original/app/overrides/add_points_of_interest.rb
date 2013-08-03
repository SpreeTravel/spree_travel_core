Deface::Override.new(
    :virtual_path => 'spree/products/show',
    :name => 'add_points_of_interest',
    :insert_bottom => "[data-hook='product_left_part_wrap']",
    :partial => "spree/products/product_points"
)