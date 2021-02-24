# frozen_string_literal: true

module Spree::LineItemDecorator
  def self.prepended(base)
    base.has_many :paxes, class_name: 'Spree::Pax', dependent: :destroy
    base.belongs_to :context, class_name: 'Spree::Context'
    base.belongs_to :rate, class_name: 'Spree::Rate'

    base.accepts_nested_attributes_for :paxes
    base.accepts_nested_attributes_for :context

    base.attr_accessor :context_price
  end

  def context_attributes=(attr)
    return if attr.nil?
    attr = attr.merge({line_item_id: id})
    context.set_persisted_option_values(attr)
    copy_price
  end

  def copy_price
    if variant
      if variant.product_type.present?
        update_travel_price
      else
        update_price if price.nil?
      end
      self.cost_price = variant.cost_price if cost_price.nil?
      self.currency = variant.currency if currency.nil?
    end
  end

  def update_travel_price
    # TODO: take into account here the currency change, i am not taking it now
    # TODO: this has to be improved, regarding the comparinson with the rate.
    if context_price
      self.price = context_price.gsub(/[$,]/,'').to_f
    else
      variant.product.calculate_price(context, variant, temporal:false).each do |hash|
        self.price = hash[:price].match(/(\d.+)/)[1].gsub(',','').to_f if self.rate.id == hash[:rate]
      end
    end
  end
end

Spree::LineItem.prepend Spree::LineItemDecorator
