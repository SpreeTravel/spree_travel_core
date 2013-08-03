Deface::Override.new(:virtual_path => "spree/admin/orders/show",
                         :name => "add_confirm_button",
                         :insert_bottom => "[data-hook='admin_order_show_buttons']",
                         :text => "<%= button_link_to t('confirm'), fire_admin_order_url(@order.number, {:e => 'confirm'}) if @order.state != 'confirmed' %>"
)
