module Spree
  module BaseHelper

    def partial_name_for_product(product, view)
      name = if product.product? then 'generic' else product.class_name(:view) end
      "spree/shared/#{name}_#{view}"
    end
  end
end
