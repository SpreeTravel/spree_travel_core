module Spree
  class Rate <  ActiveRecord::Base

    include Spree::DynamicAttribute

    def self.excluded_list
      ['variant_id', 'variant=']
    end

    belongs_to :variant, :class_name => 'Spree::Variant', :foreign_key => 'variant_id'
    has_many :option_values, :class_name => 'Spree::RateOptionValue', :foreign_key => 'rate_id', :dependent => :destroy
    has_many :combinations, :class_name => 'Spree::Combinations', :foreign_key => 'rate_id'

    after_save :generate_combinations
    before_destroy :destroy_combinations

    def generate_combinations
      variant.product.generate_combinations(self)
    rescue Exception => ex
      Log.exception(ex)
    end

    def destroy_combinations
      variant.product.destroy_combinations(self)
    rescue
    end

    # TODO: poner una restriccion para evitar solapamiento de fechas o al menos evitar que las
    # que se solapen tengan el mismo position

    def start_date
      get_option_value(:start_date)
    end

    def end_date
      get_option_value(:end_date)
    end

    def plan
      get_option_value(:plan)
    end

    def simple
      get_option_value(:simple)
    end

    def double
      get_option_value(:double)
    end

    def triple
      get_option_value(:triple)
    end

    def first_child
      get_option_value(:first_child)
    end

    def second_child
      get_option_value(:second_child)
    end

    def one_adult
      get_option_value(:one_adult).to_i
    end

    def one_child
      get_option_value(:one_child).to_i
    end
  end
end
