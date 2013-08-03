Deface::Override.new(:virtual_path => "spree/shared/_taxonomies",
                      :name => "show_search_partials_facets",
                      :insert_before => "#taxonomies",
                      :partial => "spree/products/facets",
                      :disabled => true,
                      :original => '17b889dc86a84f03d6831a512f5c5e80e56024c4')

