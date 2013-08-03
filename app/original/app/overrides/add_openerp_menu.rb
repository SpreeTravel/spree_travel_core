Deface::Override.new(
    :virtual_path => 'spree/layouts/admin',
    :name => 'add_openerp_menu',
    :insert_bottom => "[data-hook='admin_tabs']",
    :text => "<% 'tab :openerp' %>"
)
