Deface::Override.new(
    :virtual_path => 'spree/shared/_promotions',
    :name => 'add_attributes_to_promotions',
    :set_attributes => "[data-hook='homepage_promotions']",
    :attributes => {:class => 'hp_promotions'}
)

