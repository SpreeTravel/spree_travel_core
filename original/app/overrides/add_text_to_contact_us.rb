Deface::Override.new(:virtual_path => "spree/contact/show",
		     :name => "add_text_to_contacts_us",
		     :insert_top => "[data-hook='contact']",
		     :partial =>  "spree/shared/custom_contacts",
         :disabled => true
		     
)
