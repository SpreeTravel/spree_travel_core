Deface::Override.new(:virtual_path  => "spree/layouts/spree_application",
                     :name          => "change_main_menu",
                     :insert_bottom => "#main-nav-bar[data-hook]",
                     :partial  => "spree/shared/main_menu_items",
                     :original => '099ee5514ed37996cba52fcc8d1fc198e9b47bcc',
                     :disabled => false)

Deface::Override.new(:virtual_path  => "spree/layouts/spree_application",
                     :name          => "erase_home_link_text",
                     :remove => "#home-link[data-hook]",
                     :disabled => true)

Deface::Override.new(:virtual_path  => "spree/layouts/spree_application",
                     :name          => "erase_cart_link",
                     :remove => "#link-to-cart[data-hook]",
                     :disabled => true)

