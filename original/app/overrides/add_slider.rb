Deface::Override.new(:virtual_path  => "spree/layouts/spree_application",
                     :name          => "add_slider",
                     :insert_before => "#wrapper[data-hook]",
                     :partial  => "spree/shared/top_slider",
                     :disabled => true)