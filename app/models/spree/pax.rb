module Spree
  class Pax < ActiveRecord::Base
    belongs_to :line_item

  end
end
