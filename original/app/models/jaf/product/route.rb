module Jaf
  module Product
    module Route
    def route?
        type_is?('route')
    end

    def part_of_route?
        parent_route != nil
    end

    def main_part_of_route
        this_is_related_to_me('is_main_part_of_route')
    end

    def sub_routes
        list = they_are_related_to_me('is_part_of_route')
        main = main_part_of_route
        [main] + list
    end

    def parent_route
        i_am_related_to_this('is_part_of_route') || i_am_related_to_this('is_main_part_of_route')
    end
    end
  end
end
