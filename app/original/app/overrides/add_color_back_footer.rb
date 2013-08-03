Deface::Override.new(:virtual_path  => "spree/layouts/spree_application",
                     :name          => "add_color_back_footer",
                     :insert_bottom => "[data-hook='body']",
                     :partial  => "spree/shared/color_back_footer",
                     :disabled => true)