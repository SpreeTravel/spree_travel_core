Deface::Override.new(:virtual_path => "spree/products/_rooms",
                     :name => "review_to_hotel",
                     :insert_bottom => "[data-hook='product_right_part']",
                     :partial => "spree/shared/reviews",
                     :disabled => false)

Deface::Override.new(:virtual_path => "spree/products/_show_programs",
                     :name => "review_to_programs",
                     :insert_bottom => "[data-hook='product_right_part']",
                     :partial => "spree/shared/reviews",
                     :disabled => false)