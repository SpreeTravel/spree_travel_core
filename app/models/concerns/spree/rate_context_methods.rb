# frozen_string_literal: true

module Spree
  module RateContextMethods
    extend ActiveSupport::Concern

    def persist(option_type, value)
      if destination?(option_type) || selection?(option_type)
        self.option_value_id = value
        save!
      elsif price?(option_type)
        save_price_records(option_type, value)
      elsif date?(option_type) || pax?(option_type)
        save_value_records(option_type.attr_type, option_type, value)
      else
        raise StandardError, 'this attr_type is not supported'
      end
    end

    def persisted(option_type, attr = nil)
      if destination?(option_type) || selection?(option_type)
        option_value.send(attr)
      elsif price?(option_type)
        price_in('USD').display_price_including_vat_for({ tax_zone: Spree::Zone.default_tax }).money
      elsif date?(option_type)
        value.date
      elsif pax?(option_type)
        value.pax
      end
    end

    private

    def save_price_records(option_type, value)
      self.option_value = option_type.option_values.take
      ApplicationRecord.transaction do
        self.price = value.to_i
        save!
      end
    end

    def save_value_records(attr, option_type, value)
      self.option_value = option_type.option_values.first

      ApplicationRecord.transaction do
        save!

        record = Spree::Value.find_by(valuable: self)

        if record
          record.update!(attr => value)
        else
          Spree::Value.create!(valuable: self, attr => value)
        end
      end
    end

    def destination?(option_type)
      option_type.attr_type == 'destination'
    end

    def selection?(option_type)
      option_type.attr_type == 'selection'
    end

    def pax?(option_type)
      option_type.attr_type == 'pax'
    end

    def date?(option_type)
      option_type.attr_type == 'date'
    end

    def price?(option_type)
      option_type.attr_type == 'price'
    end
  end
end
