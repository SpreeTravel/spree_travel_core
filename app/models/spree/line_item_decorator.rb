module Spree
  LineItem.class_eval do
    has_many :paxes, :class_name => "Spree::Pax", :dependent => :destroy
    has_one :context, :class_name => "Spree::Context"

    accepts_nested_attributes_for :paxes
  end
end
