module Spree
  LineItem.class_eval do
    has_many :paxes, :class_name => "Spree::Pax", :dependent => :destroy
    has_one :context, :class_name => "Spree::Context"

    accepts_nested_attributes_for :paxes


    def copy_price
    #   TODO look into this method, is empty because the logic is in
    #   'add_to_line_item' in the OrderContentDecorator
    #   i could not pass the 'rate' to this method

    end


  end
end
