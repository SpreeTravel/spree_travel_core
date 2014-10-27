FactoryGirl.define do
  factory :option_value_decorated, class: Spree::OptionValue do
    option_type_decorated
    sequence(:name) { |n|
      presentation = "Option Value ##{n}"
      "product_type_##{n}"
    }
    enabled true
  end
end