FactoryGirl.define do
  factory :option_type_decorated, class: Spree::OptionType do
    name 'selection_option_type'
    sequence(:presentation){|n| "Option Type #{n}"}
    position 0
    attr_type 'selection'

    factory :selection_option_type do
      sequence(:presentation){|n| "Selection Option Type #{n}"}
      attr_type 'selection'
    end

    factory :date_option_type do
      name 'date_option_type'
      sequence(:presentation){|n| "Date Option Type #{n}"}
      attr_type 'date'
    end

    factory :integer_option_type do
      name 'integer_option_type'
      sequence(:presentation){|n| "Integer Option Type #{n}"}
      attr_type 'integer'
    end

    factory :float_option_type do
      name 'float_option_type'
      sequence(:presentation){|n| "Float Option Type #{n}"}
      attr_type 'float'
    end

  end
end