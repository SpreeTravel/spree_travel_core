# frozen_string_literal: true

# TODO: relate this model with Spree::Price for having multicurrency support
module Spree
  class Rate < Spree::Base
    include Spree::PersistedDynamicAttribute

    def self.excluded_list
      ['variant_id', 'variant=']
    end

    belongs_to :variant, class_name: 'Spree::Variant', foreign_key: 'variant_id'
    has_many :option_values, class_name: 'Spree::RateOptionValue', foreign_key: 'rate_id', dependent: :delete_all
    has_many :line_items, class_name: 'Spree::LineItem'

    def first_time!
      @first_time = true
    end

    def first_time?
      @first_time
    end

    def find_existing_option_value(option_type)
      option_values.includes(option_value: :option_type)
                   .find { |ov| ov.option_value&.option_type_id == option_type.id }
    end

    # Spree::ProductType.all.map {|pt| pt.rate_option_types.pluck(:name)}.flatten.each do |rate_option_type|
    #   define_method rate_option_type do
    #     get_persisted_option_value(rate_option_type)
    #   end
    # end

    # TODO: add restriction over dates overlapsed

    %i[
      start_date end_date plan simple double triple
      first_child second_child one_adult
    ].each do |method|
      define_method method do
        get_persisted_option_value(method)
      end
    end
  end
end
