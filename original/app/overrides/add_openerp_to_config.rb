Deface::Override.new(
    :virtual_path => 'spree/admin/configurations/index',
    :name => 'add_openerp_to_config',
    :insert_bottom => "[data-hook='admin_configurations_menu']",
    :partial => "spree/admin/configurations/openerp"
)
