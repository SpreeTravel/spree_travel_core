FactoryBot.define do
  factory :option_type_decorated, class: Spree::OptionType do
    sequence(:name, 'a'){ |n| "option_type_#{n}" }
    sequence(:presentation, 'a'){|n| "Option Type #{n}"}
    position          { 0 }
    attr_type         { 'selection' }
    travel            { true }
    preciable         { false }

    trait :with_selection_option_type_and_values do
      sequence(:name, 'a'){ |n| "selection_option_type_#{n}" }
      sequence(:presentation, 'a'){|n| "Selection Option Type #{n}"}
      attr_type {'selection'}

      after(:create) {|option_type| option_type.option_values = [create(:option_value, option_type: option_type)]}
    end

    trait :with_price_option_type do
      sequence(:name, 'a'){ |n| "price_option_type_#{n}" }
      sequence(:presentation, 'a'){|n| "Price Option Type #{n}"}
      attr_type  {'price'}
    end

    trait :with_date_option_type do
      sequence(:name, 'a'){ |n| "date_option_type_#{n}" }
      sequence(:presentation, 'a'){|n| "Date Option Type #{n}"}
      attr_type  {'date'}
    end

    trait :with_pax_option_type do
      sequence(:name, 'a'){ |n| "pax_option_type_#{n}" }
      sequence(:presentation, 'a'){|n| "Pax Option Type #{n}"}
      attr_type {'pax'}
    end

    trait :with_float_option_type do
      sequence(:name, 'a'){ |n| "float_option_type_#{n}" }
      sequence(:presentation, 'a'){|n| "Float Option Type #{n}"}
      attr_type {'float'}
    end

    trait :preciable do
      preciable { true }
    end
  end
end