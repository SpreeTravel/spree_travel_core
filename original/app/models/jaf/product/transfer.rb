module Jaf
  module Product
    module Transfer

    def transfer_parts(options = {})
        options[:limit] = Constant::MAX_RELATION
        list = they_are_related_to_me('is_part_of_transfer', :limit => options[:limit])
        main = main_transfer_part
        [main] + list
    end

    def main_transfer_part
        this_is_related_to_me('is_main_part_of_transfer')
    end

    def part_of_transfer?
        parent_transfer != nil
    end

    def parent_transfer
        i_am_related_to_this('is_part_of_transfer') || i_am_related_to_this('is_main_part_of_transfer')
    end
    end
  end
end
