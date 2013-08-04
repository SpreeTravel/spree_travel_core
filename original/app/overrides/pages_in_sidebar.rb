Deface::Override.new(:virtual_path => "spree/home/page",
                     :name => "pages_in_sidebar",
                     :insert_top => "[data-hook='homepage_sidebar_navigation']",
                     :partial => "spree/static_content/static_content_sidebar")
