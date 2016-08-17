Deface::Override.new(
    :virtual_path => 'spree/admin/orders/_line_items',
    :name => 'add_option_types_to_order',
    :replace => "[data-hook='line-items']",
    :partial => "spree/admin/orders/line_item_option_types"
)
