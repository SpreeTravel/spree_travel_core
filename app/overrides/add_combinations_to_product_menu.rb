Deface::Override.new(
    :virtual_path => 'spree/admin/shared/_product_tabs',
    :name => 'add_combinations_to_product_menu',
    :insert_bottom => "[data-hook='admin_product_tabs']",
    :partial => "spree/admin/shared/product_combination_tab",
    :disabled => false
)
