Deface::Override.new(
    :virtual_path => 'spree/shared/_products',
    :name => 'change_product_list',
    :replace => "[data-hook='products_list_item']",
    :partial => "spree/shared/product_in_one_line",
    :disabled => true
)