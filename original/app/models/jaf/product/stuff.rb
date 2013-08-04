module Jaf
  module Product
    module Stuff

      #alias old_images images

      def children
        if hotel?
          children_rooms
        elsif package?
          package_members
        elsif transfer?
          transfer_parts
        elsif destination?
          sub_destinations
        elsif route?
          sub_routes + points_of_interest
        else
          []
          # TIPO DE PRODUCTO QUE NO DEBE TENER HIJOS
        end
      end

      def parent
        if room?
          parent_hotel
        elsif part_of_package?
          parent_package
        elsif part_of_transfer?
          parent_transfer
        elsif part_of_destination?
          parent_destination
        elsif part_of_route?
          parent_route
        else
          nil
        end
      end

      def main_child
        if hotel?
          main_room
        elsif package?
          main_part_of_package
        elsif transfer?
          main_transfer_part
        elsif destination?
          main_part_of_destination
        elsif route?
          main_part_of_route
        else
          nil
        end
      end

      def main_variant
        if hotel?
          main_room.cheapeast_variant
        elsif room?
          cheapeast_variant
        elsif package?
          main_part_of_package.master
        elsif part_of_package?
          master
        elsif transfer?
          main_transfer_part.master
        elsif part_of_transfer?
          master
        elsif destination?
            main_part_of_destination.master
        elsif part_of_destination?
            master
        elsif route?
            main_part_of_route.master
        elsif part_of_route?
            master
        else
            nil
        end
    end

    def lat
        latitude
    end

    def lng
        longitude
    end

    def has_location?
        lat.present? && lng.present?
    end

    #def images
    #    if self.package?
    #        members = self.package_members
    #        if members.length > 0
    #            members.map(&:images).flatten
    #        else
    #            old_images
    #        end
    #    else
    #        if old_images.length == 0
    #            if parent
    #                parent.images
    #            else
    #                []
    #            end
    #        else
    #            old_images
    #        end
    #    end
    #end

    def category
        #self.taxons.map(&:name).join(',')
        list = []
        self.taxons.each do |taxon|
          if taxon.taxonomy_id == Spree::Taxon.find_by_permalink('categories').taxonomy_id ||
              taxon.taxonomy_id == Spree::Taxon.find_by_permalink('things-to-do').taxonomy_id
            array = []
            array << taxon.name
            while taxon.parent != nil
                taxon = taxon.parent
                array << taxon.name
            end
            array = [array[-2], array[0]]
            list << array.join(" | ")
          end
        end
        list.join("<br>").html_safe
    end

      def destination
        list = []
        self.taxons.each do |taxon|
          if taxon.taxonomy_id == Spree::Taxon.find_by_permalink('destinations').taxonomy_id
            array = []
            array << taxon.name
            while taxon.parent != nil
              taxon = taxon.parent
              array << taxon.name
            end
          array = [array[-2], array[0]]
          list << array.join(" | ")
          end
        end
        list.join("<br>").html_safe
      end


    # TODO: aqiu se deben mostrar los que estan relacionados con la relacion 'is_point_of_interest'
    def points_of_interest(options = {})
        product = self
        if self.destination?
          p = product.get_product_to_map_from_destination
          product = p if p
        end

        options[:limit] ||= 30
        list = product.nearest(options)
        new_list = []
        list.each do |p|
          new_list << p if p.accommodation?
          new_list << p if p.program?
          new_list << p if p.tour?
          new_list << p if p.point?
        end
        new_list[0..15]
    end

    def nearest(options = {})
        options[:distance]     ||= 20
        options[:limit]        ||= 10
        options[:include_self] ||= false
        options[:under_taxon]  ||= nil
        list  = Spree::Product.find(:all, :origin => self, :within => options[:distance],:limit => options[:limit], :order=>'distance asc', :conditions => 'deleted_at IS NULL')
        list -= [self] unless options[:include_self]
        list
    end

    def all_variants
        Spree::Variant.where(:product_id => self.id)
    end

    #TODO hay que revisar esto, pues da un error, creo que no comprueba si tiene productos asociados
    def product_price
        if self.hotel?
          if main_room
            main_room.cheapeast_variant.price
          end
        elsif self.room?
            cheapeast_variant.price
        else
            self.price
        end
    end

    def bottom_taxon
        return nil if taxons.length == 0
        taxons[0]
    end

    def bottom_taxon_name
        if bottom_taxon
            bottom_taxon.name
        else
            ""
        end
    end

    def taxon_chain
        array = []
        return array unless bottom_taxon
        current = bottom_taxon
        while current.parent != nil
            array << current
            current = current.parent
        end
        array
    end

    def top_taxon
        taxon_chain[-1]
    end

    def last_taxons_str
        taxon_chain[0..-2].reverse.map(&:name).join('/')
    end

    def similar(type)
        #"#{type.to_s.gsub('-', ' ').pluralize.capitalize} / #{bottom_taxon.name}"
        "#{type.to_s.gsub('-', ' ').upcase}"
    end

    def similar_link(type, prefix = 'categories')
        "#{prefix}/#{type.to_s}/#{last_taxons_str}"
    end
    end
  end
end
