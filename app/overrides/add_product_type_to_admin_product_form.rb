Deface::Override.new(:virtual_path => "spree/admin/products/new",
                     :name => "add_product_type_to_admin_product_form",
                     :insert_bottom => "[data-hook='new_product_attrs']",
                     :partial => 'spree/admin/products/type',
                     :disabled => false
)

