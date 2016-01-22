module Spree
  LineItem.class_eval do
    has_many :paxes, :class_name => "Spree::Pax", :dependent => :destroy
    belongs_to :context, :class_name => "Spree::Context"
    belongs_to :rate, class_name: "Spree::Rate"

    accepts_nested_attributes_for :paxes


    def copy_price
      if variant
        # TODO take into account here the currency change
        self.price = variant.product.calculate_price(context, variant, temporal:false).first[:price]
        self.cost_price =  rate.variant.cost_price if cost_price.nil?
        self.currency =  rate.variant.currency if currency.nil?
      end
    end

  end
end
