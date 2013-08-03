Deface::Override.new(
    :virtual_path => 'spree/admin/properties/index',
    :name => 'modify_property_list',
    :replace => "#listing_properties[data-hook]",
    :partial => "spree/admin/properties/property_list"
)
