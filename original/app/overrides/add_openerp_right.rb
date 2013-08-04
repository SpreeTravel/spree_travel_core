Deface::Override.new(
    :virtual_path => 'spree/admin/shared/_configuration_menu',
    :name => 'add_openerp_right',
    :insert_bottom => "[data-hook='admin_configurations_sidebar_menu']",
    :text => "<%= configurations_sidebar_menu_item t('openerp'), '/admin/openerp' %>"
)
