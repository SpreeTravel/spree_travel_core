module Spree
  class Calculator::Pax < Calculator

    def self.description
      "Flight and Tours calculator"
    end

    def self.register
      super
      ProductCustomizationType.register_calculator(self)
    end

    def create_options
      [
       type = Spree::Calculator.find_by_type("Spree::Calculator::Pax").calculable_id,
       CustomizableProductOption.create(:name=>"adults", :presentation=>"Adults", :description => '',
                                        :product_customization_type_id => type),
       CustomizableProductOption.create(:name=>"adults_price", :presentation=>"ap", :description => '',
                                        :product_customization_type_id => type),
       CustomizableProductOption.create(:name=>"children", :presentation=>"Children", :description => '',
                                        :product_customization_type_id => type),
       CustomizableProductOption.create(:name=>"children_price", :presentation=>"cp", :description => '',
                                        :product_customization_type_id => type)
      ]
    end

    def compute(product_customization,variant=nil)
      adults = get_option(product_customization, "adults")
      adults_price = get_option(product_customization, "adults_price")
      children = get_option(product_customization, "children")
      children_price = get_option(product_customization, "children_price")
      (adults.value.to_i * adults_price.value.to_i) + (children.value.to_i * children_price.value.to_i)
    end
    
	private
    def get_option(product_customization, name)
      product_customization.customized_product_options.detect {|cpo| cpo.customizable_product_option.name == name }
    end
    
  end
end
