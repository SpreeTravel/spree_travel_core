# frozen_string_literal: true

module Spree
  module OptionTypeDecorator
    def self.prepended(base)
      base.validates_uniqueness_of :name
      # base.validates_format_of :name, with: /\A[a-z_]+\z/, message: "can only contains lowercase letters and '_'"
      base.validates :attr_type, presence: true, if: :travel?
      base.after_create :default_option_value
    end

    def default_option_value
      if attr_type != 'selection' && option_values.empty? && travel
        Spree::OptionValue.create(name: name,
                                  presentation: presentation,
                                  option_type_id: id)
      end
    end
  end
end

Spree::OptionType.prepend Spree::OptionTypeDecorator

module Spree
  class SelectionOptionType
    def self.save(context_or_rate_option_value, value, option_type = nil)
      context_or_rate_option_value.option_value_id = value
      context_or_rate_option_value
    end

    def self.value(context_or_rate_option_value)
      context_or_rate_option_value.option_value.send('presentation')
    end

    def self.find_option_value(option_type)
      puts 'to implement'
    end
  end

  class PriceOptionType
    def self.save(context_or_rate_option_value, value, option_type)
      context_or_rate_option_value.option_value = option_type.option_values.take
      context_or_rate_option_value.price = value.to_i
      context_or_rate_option_value.save
    end

    def self.value(context_or_rate_option_value)
      # TODO: sustitude USD by current_currency
      context_or_rate_option_value.price_in('USD')
                                  .display_price_including_vat_for({ tax_zone: Spree::Zone.default_tax })
                                  .money
    end

    def self.find_option_value(option_type)
      where(option_value_id: nil)
    end
  end

  class DestinationOptionType
    def self.save(context_or_rate_option_value, value, option_type = nil)
      context_or_rate_option_value.option_value_id = value
      context_or_rate_option_value.save!
    end

    def self.value(context_or_rate_option_value)
      context_or_rate_option_value.option_value.send('presentation')
    end

    def self.find_option_value(option_type)
      puts 'to implement'
    end
  end

  class DateOptionType
    def self.save(context_or_rate_option_value, value, option_type)
      context_or_rate_option_value.option_value = option_type.option_values.first
      context_or_rate_option_value.date_value = value
      context_or_rate_option_value.save!
    end

    def self.value(context_or_rate_option_value)
      context_or_rate_option_value.date_value
    end

    def self.find_option_value(option_type)
      joins(:option_value).where('spree_option_values.option_type_id == ?', option_type.id)
    end
  end

  class PaxOptionType
    def self.save(context_or_rate_option_value, value, option_type)
      context_or_rate_option_value.option_value = option_type.option_values.first
      context_or_rate_option_value.pax_value = value
      context_or_rate_option_value.save!
    end

    def self.value(context_or_rate_option_value)
      context_or_rate_option_value.pax_value
    end

    def self.find_option_value(option_type)
      joins(:option_value).where('spree_option_values.option_type_id == ?', option_type.id)
    end
  end
end