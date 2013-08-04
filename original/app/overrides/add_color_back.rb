Deface::Override.new(:virtual_path  => "spree/layouts/spree_application",
                     :name          => "add_color_back",
                     :insert_top => "[data-hook='body']",
                     :partial  => "spree/shared/color_back",
                     :original => 'f1e5ba955ddfb59c1cb98daf6e94dba66936087b',
                     :disabled => false)