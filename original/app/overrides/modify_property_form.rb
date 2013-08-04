Deface::Override.new(
    :virtual_path => 'spree/admin/properties/_form',
    :name => 'modify_property_form',
    :insert_bottom => "[data-hook='admin_property_form']",
    :partial => "spree/admin/properties/property_type_form"
)
