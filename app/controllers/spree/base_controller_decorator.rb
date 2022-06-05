
module Spree::BaseControllerDecorator
  def self.prepended(base)

    include Spree::StrongParametersDecorator

  end
end

# Spree::BaseController.prepend Spree::BaseControllerDecorator