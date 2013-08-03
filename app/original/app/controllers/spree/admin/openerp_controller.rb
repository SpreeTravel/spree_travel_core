module Spree
    module Admin
        class OpenerpController < BaseController

            def index
              respond_to do |format|
                format.html
              end
            end

            def import_data
                @data = "some here"
                #OpenerpLoader.import_all_openerp
            end

            def import_taxonomy
              @data = "some here"
              #OpenerpLoader.import_all_openerp
            end

            def import_all_products

            end

            def import_one_product(product)

            end

            def import_product_taxonomy

            end

            def import_all_routes

            end

            def import_one_route(route)

            end

            def import_route_taxonomy

            end

            def import_all_destinies

            end

            def import_one_destiny(destiny)

            end

            def import_destiny_taxonomy

            end

            def import_all_points

            end

            def import_one_point(point)

            end

            def import_point_taxonomy

            end

        end
    end
end
