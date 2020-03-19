module Spree::LineItemDecorator
  def self.prepended(base)
    base.has_many :paxes, class_name: "Spree::Pax", dependent: :destroy
    base.belongs_to :context, class_name: "Spree::Context"
    base.belongs_to :rate, class_name: "Spree::Rate"

    base.accepts_nested_attributes_for :paxes
  end

  def copy_price
    if variant
      if variant.product.product_type.present?
        # TODO take into account here the currency change, i am not taking it now
        # TODO this has to be improved, regarding the comparinson with the rate.
        variant.product.calculate_price(context, variant, temporal:false).each do |hash|
          if self.rate.id == hash[:rate]
            self.price = hash[:price].match(/(\d.+)/)[1].gsub(',','').to_f
          end
        end
        # self.price = variant.product.calculate_price(context, variant, temporal:false).first[:price]
        self.cost_price =  variant.cost_price if cost_price.nil?
        self.currency =  variant.currency if currency.nil?
      else
        update_price if price.nil?
        self.cost_price = variant.cost_price if cost_price.nil?
        self.currency = variant.currency if currency.nil?
      end
    end
  end

end

Spree::LineItem.prepend Spree::LineItemDecorator