module Spree
  LineItem.class_eval do
    has_many :paxes, :class_name => "Spree::Pax", :dependent => :destroy
    has_one :context, :class_name => "Spree::Context"
    belongs_to :rate, class_name: "Spree::Rate"

    accepts_nested_attributes_for :paxes


    def copy_price
      if variant
        self.price = rate.variant.calculate_price(context, rate, :temporal => false )[:price]
        self.cost_price =  rate.variant.cost_price if cost_price.nil?
        self.currency =  rate.variant.currency if currency.nil?
      end
    end


  end
end
