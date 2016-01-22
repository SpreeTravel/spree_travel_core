Deface::Override.new(:virtual_path => "spree/admin/variants/_form",
                     :name => "remove_variant_edit_left_column",
                     :remove => "[data-hook='admin_variant_form_additional_fields']",
                     :disabled => false
)
