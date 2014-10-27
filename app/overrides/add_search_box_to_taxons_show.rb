Deface::Override.new(
    :virtual_path => 'spree/taxons/show',
    :name => 'add_search_box_to_taxons_show',
    :insert_before => "[data-hook='taxon_products']",
    :partial => "spree/taxons/search_box_taxon",
    :disabled => true
)
