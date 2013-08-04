Deface::Override.new(:virtual_path => "spree/layouts/admin",
		     :name => "add_ckeditor_to_admin_layout_header",
		     :insert_bottom => "[data-hook='admin_inside_head']",
		     :text =>  "<%= javascript_include_tag 'ckeditor/init' %>"                 
		     
)
