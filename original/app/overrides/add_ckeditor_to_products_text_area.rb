Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                     :name => "add_ckeditor_to_text_area",
                     :replace => "[data-hook='admin_product_form_left']",
                     :partial => "spree/admin/products/ckeditor_textarea"
)

Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                     :name => "remove_admin_product_shipping",
                     :replace => "[data-hook='admin_product_form_right']",
                     :partial => "spree/admin/products/admin_product_shipping" ,
                     :disable => false
)

Deface::Override.new( :virtual_path => "spree/admin/products/_form",
                      :name => "modify_admin_product_form",
                      :insert_bottom => "[data-hook='admin_product_form_right']",
                      :partial => "spree/admin/products/product_form",
                      :sequence => {:after => "remove_admin_product_shipping"}
)


