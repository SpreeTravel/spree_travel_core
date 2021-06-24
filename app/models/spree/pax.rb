# frozen_string_literal: true

module Spree
  class Pax < Spree::Base
    belongs_to :line_item
  end
end
