Deface::Override.new(:virtual_path => "spree/admin/products/new",
                     :name => "add_taxon_to_admin_product_new",
                     :insert_bottom => '[data-hook="new_product_attrs"]',
                     :partial => 'spree/admin/products/taxon',
                     :disabled => false
)
