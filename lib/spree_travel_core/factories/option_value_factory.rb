FactoryGirl.define do
  factory :option_value_decorated, class: Spree::OptionValue do
    option_type_decorated
    sequence(:name) { |n| "product_type_##{n}" }
    sequence(:presentation} { |n| "Option Value ##{n}" }
    enabled true
  end
end