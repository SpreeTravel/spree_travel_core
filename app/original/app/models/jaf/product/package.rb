module Jaf
  module Product
    module Package
    def package?
        type_is?('Package')
    end

    def part_of_package?
        parent_package != nil
    end

    def parent_package
        i_am_related_to_this('is_part_of_package') || i_am_related_to_this('is_main_part_of_package')
    end

    def main_part_of_package
        they_are_related_to_me('is_main_part_of_package')
    end

    def package_members
        rest = they_are_related_to_me('is_part_of_package')
        main_part_of_package + rest
    end
    end
  end
end
