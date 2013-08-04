module Spree
  class Calculator::CheckInOut < Calculator

    def self.description
      "Product CheckIn and CheckOut Calculator"
    end

    def self.register
      super
      ProductCustomizationType.register_calculator(self)
    end

    def create_options
      # This calculator knows that it needs one CustomizableOption named customization_image
      [
       CustomizableProductOption.create(:name=>"check_in", :presentation=>"Check In", :description => ''),
       CustomizableProductOption.create(:name=>"check_out", :presentation=>"Check Out", :description => '')
      ]
    end

    def compute(product_customization,variant=nil)
      return 0 unless valid_configuration? product_customization
      check_in = get_option(product_customization, "check_in")
      check_out = get_option(product_customization, "check_out")
      check_out.value.to_date - check_in.value.to_date
    end
   
    def valid_configuration?(product_customization)
      all_opts = product_customization.customized_product_options.map {|cpo| cpo.customizable_product_option.name }
      # do we have the necessary inputs?
      has_inputs = all_opts.include?("check_in") && all_opts.include?("check_out")
      # do the inputs meet the criteria?
      width,height = get_option(product_customization, "check_in"), get_option(product_customization, "check_out")
      return true
    end
    
	private
    def get_option(product_customization, name)
      product_customization.customized_product_options.detect {|cpo| cpo.customizable_product_option.name == name }
    end
    
  end
end
