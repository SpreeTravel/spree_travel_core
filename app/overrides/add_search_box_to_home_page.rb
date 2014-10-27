Deface::Override.new(
    :virtual_path => 'spree/shared/_products',
    :name => 'add_search_box_to_home_page',
    :insert_before => "[data-hook='products_search_results_heading']",
    :partial => "spree/home/search_box_home",
    :disabled => false
)
