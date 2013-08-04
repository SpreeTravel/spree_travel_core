Spree::ProductProperty.class_eval do
  attr_accessible :property_name, :property_id, :product_id, :value
end
