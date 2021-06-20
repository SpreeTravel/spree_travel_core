# frozen_string_literal: true

module Spree
  class Value < Spree::Base
    belongs_to :valuable, polymorphic: true

    validates :valuable, presence: true
  end
end
