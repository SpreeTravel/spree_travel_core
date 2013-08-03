Deface::Override.new(
    :virtual_path => 'spree/admin/configurations/index',
    :name => 'add_property_type',
    :insert_bottom => "[data-hook='admin_configurations_menu']",
    :partial => "spree/admin/configurations/property_type"
)
