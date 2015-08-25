module Spree
  class Rate <  ActiveRecord::Base

    include Spree::PersistedDynamicAttribute

    def self.excluded_list
      ['variant_id', 'variant=']
    end

    belongs_to :variant, :class_name => 'Spree::Variant', :foreign_key => 'variant_id'
    has_many :option_values, :class_name => 'Spree::RateOptionValue', :foreign_key => 'rate_id', :dependent => :delete_all

    def first_time!
      @first_time = true
    end

    def first_time?
      @first_time
    end

    # TODO: poner una restriccion para evitar solapamiento de fechas o al menos evitar que las
    # que se solapen tengan el mismo position

    def start_date
      get_persisted_option_value(:start_date)
    end

    def end_date
      get_persisted_option_value(:end_date)
    end

    def plan
      get_persisted_option_value(:plan)
    end

    def simple
      get_persisted_option_value(:simple)
    end

    def double
      get_persisted_option_value(:double)
    end

    def triple
      get_persisted_option_value(:triple)
    end

    def first_child
      get_persisted_option_value(:first_child)
    end

    def second_child
      get_persisted_option_value(:second_child)
    end

    def one_adult
      get_persisted_option_value(:one_adult).to_i
    end

    def one_child
      get_persisted_option_value(:one_child).to_i
    end
  end
end
