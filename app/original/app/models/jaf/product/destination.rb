module Jaf
  module Product
    module Destination

    def main_part_of_destination
        this_is_related_to_me('is_main_part_of_destination')
    end

    def sub_destinations(options = {})
        options[:limit] = Constant::MAX_RELATION
        list = they_are_related_to_me('is_part_of_destination', :limit => options[:limit])
        main = main_part_of_destination
        ([main] + list).compact
    end

    def part_of_destination?
        parent_destination != nil
    end

    def parent_destination
        i_am_related_to_this('is_part_of_destination') || i_am_related_to_this('is_main_part_of_destination')
    end

    end
  end
end

