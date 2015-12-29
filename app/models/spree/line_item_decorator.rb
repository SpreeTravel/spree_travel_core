module Spree
  LineItem.class_eval do
    has_many :paxes, :class_name => "Spree::Pax", :dependent => :destroy
    has_one :context, :class_name => "Spree::Context"
    belongs_to :rate, class_name: "Spree::Rate"

    accepts_nested_attributes_for :paxes


    def copy_price
      if variant
        self.price = get_rate_price(rate, context.adult(temporal:false), context.child(temporal:false)).to_i
        self.cost_price =  rate.variant.cost_price if cost_price.nil?
        self.currency =  rate.variant.currency if currency.nil?
      end
    end


    private

    def get_rate_price(rate, adults, children)
      adults = adults.to_i
      children = children.to_i
      adults_hash = {1 => 'simple', 2 => 'double', 3 => 'triple'}
      price = adults * rate.send(adults_hash[adults]).to_f
      price += rate.first_child.to_f if children >= 1
      price += rate.second_child.to_f if children == 2
      price
    end

  end
end
