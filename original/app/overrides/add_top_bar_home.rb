Deface::Override.new(:virtual_path  => "spree/layouts/spree_application",
                     :name          => "add_top_bar_home",
                     :insert_after => "#logo[data-hook]",
                     :partial  => "spree/shared/top_bar",
                     :original => '9da1fec51b20c37311792a9bba632e90dc810f13',
		                 :disabled => false)

Deface::Override.new(:virtual_path  => "spree/layouts/spree_application",
                     :name          => "remove_spree_auth_searchbar_and_login",
                     :remove => "#top-nav-bar",
                     :original => 'fd77c543e74438e7bde113d97baeebbc1f9a8c7f',
		                 :disabled => false)


