module Spree
  Product.class_eval do

    belongs_to :product_type
    belongs_to :calculator, :class_name => 'Spree::TravelCalculator', :foreign_key => 'calculator_id'
    has_many :rates, :through => :variants

    before_create :absorb_option_types

    def absorb_option_types
      self.option_types = self.product_type.variant_option_types
    rescue

    end

    def generate_variants
      variantions(self.option_types) do |array|
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

    # TODO: poner bonito la seleccion de variantes en la creacion de
    # productos, parece que es de Spree

    private

    def variations(option_types, index = 0, array = [], &block)
      if option_types.length == index
        yield array
      else
        for option_value in options_types[index].option_values
          array[index] = option_value
          variations(option_types, index + 1, array, &block)
        end
      end
    end

  end
end
