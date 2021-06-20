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
      return unless attr_type != 'selection' && option_values.empty? && travel

      Spree::OptionValue.create(name: name,
                                presentation: presentation,
                                option_type_id: id)
    end
  end
end

Spree::OptionType.prepend Spree::OptionTypeDecorator
