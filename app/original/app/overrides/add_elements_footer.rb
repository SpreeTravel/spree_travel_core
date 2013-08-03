Deface::Override.new(:virtual_path  => "spree/layouts/spree_application",
                     :name          => "add_address_to_footer",
                     :replace => "#footer-left p",
                     :text  => "<p>© #{Time.now.year} GrandSlam Ltd. Todos los derechos reservados | Frances House, Sir William Place, St. Peter Port, Guernsey, Channel Islands GY1 4HQ
</p>",
                     :original => '91b189bde2620aa0c75e9bafaeca176ba4aeb833',
                     :disabled => false)