# frozen_string_literal: true

module Spree
  class Pax < Spree::Base
    belongs_to :line_item

    # validates_presence_of :first_name, :last_name
  end
end
