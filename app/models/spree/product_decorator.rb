module Spree
  Product.class_eval do

    belongs_to :product_type
    belongs_to :calculator, :class_name => 'Spree::TravelCalculator', :foreign_key => 'calculator_id'
    has_many :rates, :through => :variants

    before_create :absorb_prototype_features

    def absorb_prototype_features
      prototype = Spree::Prototype.find(prototype_id)
      self.properties = prototype.properties
      self.option_types = prototype.option_types
      self.product_type_id = prototype.product_type_id
    rescue

    end

    def rate_option_types
      self.product_type.rate_option_types
    end

    def context_option_types
      self.product_type.context_option_types
    end

    # TODO: poner bonito la seleccion de variantes en la creacion de
    # productos, parece que es de Spree

  end
end
