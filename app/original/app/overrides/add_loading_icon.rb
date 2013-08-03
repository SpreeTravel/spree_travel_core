Deface::Override.new(:virtual_path  => "spree/layouts/spree_application",
                     :name          => "add_loading_icon",
                     :insert_top => "[data-hook='body']",
                     :partial =>  "spree/shared/loading_icon",
                     :original => 'f1e5ba955ddfb59c1cb98daf6e94dba66936087b',
                     :disabled => true)
