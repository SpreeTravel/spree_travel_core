Deface::Override.new(
    :virtual_path => 'spree/admin/general_settings/edit',
    :name => 'add_no_cart_preference_to_admin',
    :insert_bottom => "#preferences div.row",
    :partial => "spree/admin/general_settings/no_cart",
    :disabled => true
)
