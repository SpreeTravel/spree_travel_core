# frozen_string_literal: true

# TODO: relate this model with Spree::Price for having multicurrency support
module Spree
  class Rate < Spree::Base
    include Spree::PersistedDynamicAttribute

    def self.excluded_list
      ['variant_id', 'variant=']
    end

    belongs_to :variant,
               class_name: 'Spree::Variant',
               foreign_key: 'variant_id'
    has_many :rate_option_values,
             class_name: 'Spree::RateOptionValue',
             foreign_key: 'rate_id',
             dependent: :delete_all
    has_many :line_items, class_name: 'Spree::LineItem'

    validates_presence_of :rate_option_values

    def first_time!
      @first_time = true
    end

    def first_time?
      @first_time
    end

    def find_existing_option_value(option_type)
      rate_option_values
        .joins(:option_value)
        .where('spree_option_values.option_type_id = ?', option_type.id)
        .take
    end
  end
end
