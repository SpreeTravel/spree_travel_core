Deface::Override.new(
    :virtual_path => 'spree/shared/_products',
    :name => 'add_search_box_to_home_page',
    :insert_before => "[data-hook='products_search_results_heading']",
    :partial => "spree/shared/search_box",
    :disabled => false
)
