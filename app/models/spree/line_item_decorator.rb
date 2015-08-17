module Spree
  LineItem.class_eval do
    has_many :paxes, :class_name => "Spree::Pax", :dependent => :destroy
    has_one :context, :class_name => "Spree::Context"

    accepts_nested_attributes_for :paxes


    def copy_price
      if variant

        combinations = product.calculate_price(context, :temporal => false )

        match = []
        combinations = combinations.where(variant_id: variant.id)
        combinations.each do |c|
          if c.variant.option_values.first == variant.option_values.first
            match << c
          end
        end

        price = match.first[:price] * (context.end_date(temporal:false).to_date - context.start_date(temporal:false).to_date).to_i * context.rooms(temporal:false).to_i

        self.price = price
        self.cost_price = variant.cost_price if cost_price.nil?
        self.currency = variant.currency if currency.nil?
      end
    end


  end
end
