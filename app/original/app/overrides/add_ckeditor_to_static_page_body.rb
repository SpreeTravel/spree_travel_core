Deface::Override.new(:virtual_path => "spree/admin/pages/_form",
		     :name => "add_ckeditor_to_static_page_body",
		     :replace => "div.left",
		     :partial => "spree/shared/ckeditor_static_page"
		     
)
