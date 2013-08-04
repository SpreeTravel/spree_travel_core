Deface::Override.new(
    :virtual_path => 'spree/admin/variants/index',
    :name => 'remove_columns_in_variants_header',
    :replace => "[data-hook='variants_header']",
    :partial => "spree/admin/variants/custom_header"
)

Deface::Override.new(
    :virtual_path => 'spree/admin/variants/index',
    :name => 'remove_columns_in_variants_row',
    :replace => "[data-hook='variants_row']",
    :partial => "spree/admin/variants/custom_row"
)


