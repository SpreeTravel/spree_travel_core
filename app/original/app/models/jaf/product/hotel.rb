module Jaf
  module Product
    module Hotel

    def product_stars
        if hotel?
           self.stars
        elsif room?
            self.parent_hotel.stars
        else
            0
        end
    end

    def cheapeast_variant
        return nil unless self.room?
        return master if variants.length == 0
        return master # TODO: esto es para que no se demore mucho, luego hay que optimizar bien esto porque estaba haciendo cerca de mil consultas por producto
        all = all_variants
        current_normal = nil
        current_cheapest = all[0]
        all.each do |variant|
            current_cheapest = variant if variant.price < current_cheapest.price
            if variant.adults == 2 && variant.ninos == 0
                if current_normal
                    current_normal = variant if variant.price < current_normal.price
                else
                    current_normal = variant
                end

            end
        end
        current_normal || current_cheapest
    end

    def parent_hotel
        i_am_related_to_this('is_part_of_hotel') || i_am_related_to_this('is_main_part_of_hotel')
    end

    def hotel?
        type_is?(Constant::ACCOMMODATION)
    end

    def room?
        parent_hotel != nil
    end

    def children_rooms
        they_are_related_to_me('is_main_part_of_hotel') + they_are_related_to_me('is_part_of_hotel')
    end

    def main_room
        main =  this_is_related_to_me('is_main_part_of_hotel')
        return main if main
        return children_rooms.first if children_rooms.length > 0
        nil
    end

    def plan_alimenticio
        plan = product_properties.find {|t| t.property.name == 'meal_plan' }
    end

    end
  end
end
