module Spree
  module Core
    module Search
      class Base
        def retrieve_products
          base_scope = get_base_scope
          @products_scope = @product_group.apply_on(base_scope)
          curr_page = manage_pagination && keywords ? 1 : page
          @products = @products_scope.with_default_inclusions.page(curr_page).per(per_page)
        end

        def get_base_scope
          base_scope = @cached_product_group ? @cached_product_group.products.active : Spree::Product.active
          #base_scope = base_scope.in_taxons_at_same_time(all_taxons) if all_taxons.length > 0
          base_scope = get_products_conditions_for(base_scope, keywords)

          base_scope = base_scope.on_hand unless Spree::Config[:show_zero_stock_products]
          base_scope = base_scope.group_by_products_id if @product_group.product_scopes.size > 1
          base_scope
        end

      end
    end
  end
end
