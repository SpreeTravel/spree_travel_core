Spree::LineItem.class_eval do 

    has_many :paxes, class_name: "Spree::Pax", dependent: :destroy
    
end
