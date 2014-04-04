module Spree
  class ProductType < ActiveRecord::Base

    def self.enabled
      where(:enabled => true)
    end

  end
end
