module Spree
  LineItem.class_eval do 
    has_many :paxes, :class_name => "Spree::Pax", :dependent => :destroy
    accepts_nested_attributes_for :paxes
  end  
end
