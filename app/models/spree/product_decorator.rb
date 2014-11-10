module Spree
  Product.class_eval do
    require 'ffaker'

    belongs_to :product_type
    belongs_to :calculator, :class_name => 'Spree::TravelCalculator', :foreign_key => 'calculator_id'
    has_many :rates, :through => :variants

    before_create :absorb_option_types

    def absorb_option_types
      self.option_types = self.product_type.variant_option_types
    rescue

    end

    def generate_variants
      variations(self.option_types) do |array|
        variant = Spree::Variant.new
        variant.sku = Faker.bothify('???-######').upcase
        variant.price = 0
        variant.option_values = array
        variant.product_id = self.id
        variant.save
      end
    end

    def rate_option_types
      self.product_type.rate_option_types
    end

    def context_option_types
      self.product_type.context_option_types
    end

    def destination_taxon
      destination_taxonomy = Spree::Taxonomy.where(:name => 'Destination').first
      self.taxons.where(:taxonomy_id => destination_taxonomy.id).first
    rescue
      nil
    end

    def destination
      destination_taxon.name rescue "no place"
    end

    # TODO: poner bonito la seleccion de variantes en la creacion de
    # productos, parece que es de Spree

    private

    def variations(the_option_types, index = 0, array = [], &block)
      if the_option_types.length == index
        yield array
      else
        for option_value in the_option_types[index].option_values
          array[index] = option_value
          variations(the_option_types, index + 1, array, &block)
        end
      end
    end

  end
end
