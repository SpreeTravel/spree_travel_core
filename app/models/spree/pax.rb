module Spree
  class Pax < ActiveRecord::Base
    belongs_to :line_items
    validates_presence_of :first_name, :last_name
  end
end
