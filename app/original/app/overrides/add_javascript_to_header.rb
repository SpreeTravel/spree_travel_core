Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "add_javascript_deprecated",
                     :insert_bottom => "[data-hook='inside_head']",
                     :text =>  "<script src='http://code.jquery.com/jquery-migrate-1.2.1.js'></script>",
                     :original => 'f912df50caa7e06486ea0094e6d6a297bad85dce')
