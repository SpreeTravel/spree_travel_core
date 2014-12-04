module Spree
  Product.class_eval do
    require 'ffaker'

    belongs_to :product_type
    belongs_to :calculator, :class_name => 'Spree::TravelCalculator', :foreign_key => 'calculator_id'
    has_many :rates, :through => :variants_including_master
    has_many :combinations, :class_name => 'Spree::Combinations', :foreign_key => 'product_id'

    before_create :absorb_option_types

    def absorb_option_types
      option_types = self.product_type.variant_option_types
    rescue
    end

    def calculator_instance
      calculator.name.constantize.new
    end

    def calculate_price(context)
      calculator_instance.calculate_price(context, self).sort
    end

    def self.calculator_instance_for(product_type)
      product_type.calculator.name.constantize.new
    end

    def self.with_price(context)
      product_type = Spree::ProductType.find_by_name(context.product_type)
      string = calculator_instance_for(product_type).combination_string_for_search(context) if product_type
      list = Spree::Product.active
      list = list.where(:product_type_id => product_type.id) if product_type
      list = list.joins(:combinations)
      list = list.where('spree_combinations.start_date <= ?', context.start_date) if context.start_date.present?
      list = list.where('spree_combinations.end_date >= ?', context.end_date) if context.end_date.present?
      list = list.where('spree_combinations.adults' => context.adult) if context.adult.present?
      list = list.where('spree_combinations.children' => context.child) if context.child.present?
      list = list.where('spree_combinations.other like ?', string) if product_type
      #list = list.group('spree_products.id')
      list = list.uniq
      list
    end

    def generate_all_combinations
      calculator_instance.generate_all_combinations(self)
    end

    def generate_combinations(rate)
      calculator_instance.generate_combinations(rate)
    end

    def destroy_combinations(rate)
      calculator_instance.destroy_combinations(rate)
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
