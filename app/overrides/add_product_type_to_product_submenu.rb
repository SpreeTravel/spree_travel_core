# TODO: buscar el helper que genera el submenu
Deface::Override.new(
    :virtual_path => 'spree/admin/shared/_product_sub_menu',
    :name => 'add_product_type_to_product_submenu',
    :insert_bottom => "[data-hook='admin_product_sub_tabs']",
    :text => "<%= tab :product_types, :match_path => admin_product_types_path %>"   
)
