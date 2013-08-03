module Spree
  module Core
    class Environment
      Calculators.class_eval do
        attr_accessor :rate
      end
    end
  end
end
