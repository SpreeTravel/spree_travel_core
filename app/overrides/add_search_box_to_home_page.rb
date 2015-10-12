Deface::Override.new(
    :virtual_path => 'spree/home/index',
    :name => 'add_search_box_to_home_page',
    :replace => "[data-hook='homepage_products']",
    :partial => "spree/shared/search_box",
    :disabled => false
)
