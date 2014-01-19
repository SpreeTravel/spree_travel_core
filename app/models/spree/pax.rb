module Spree
  class Pax < ActiveRecord::Base

    belongs_to :line_items
  end   
end
