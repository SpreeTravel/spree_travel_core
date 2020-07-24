# frozen_string_literal: true

module Spree
  class TravelCalculator < Spree::Base
    belongs_to :product_type, class_name: 'Spree::ProductType', foreign_key: 'product_type_id'

    validates_presence_of :name
  end
end
