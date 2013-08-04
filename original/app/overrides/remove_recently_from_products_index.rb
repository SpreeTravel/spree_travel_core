Deface::Override.new(
    :virtual_path => "spree/shared/_products",
    :name => "remove_recently_from_products_index",
    :remove => "#recently_viewed[data-hook]",
	:sequence => {
        :after => "add_recently_viewed_products_to_products_index"
    }
)
