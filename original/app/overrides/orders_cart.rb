Deface::Override.new(:virtual_path => 'spree/orders/edit',
                     :name => 'add_cart_subtotal_to_sidebar',
                     :insert_top => "[data-hook='inside_cart_form']",
                     :partial => "spree/orders/subtotal",
                     :original => 'b416f60757fe1a25c0a9a5a53969b7dbf7613e71',
                     :disabled => false
)

