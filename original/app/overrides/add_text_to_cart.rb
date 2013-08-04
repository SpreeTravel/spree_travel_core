Deface::Override.new(:virtual_path => 'spree/products/_cart_form',
		     :name => 'add_text_to_cart',
		     :replace => "[data-hook='product_price']",
		     :partial =>  "spree/shared/cart_text",
         :disabled => true
		     
)
