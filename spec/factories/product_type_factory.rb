FactoryBot.define do
  factory :product_type, class: Spree::ProductType do
    sequence(:name)         { |n| "product_type_##{n}" }
    sequence(:presentation) { |n| "Product Type ##{n}"}
    enabled                       { true }

    trait :with_variant_option_types do
      after(:create) {|product_type| product_type.variant_option_types = [create(:option_type_decorated, :with_selection_option_type_and_values)]}
    end

    trait :with_context_option_types do
      after(:create) {|product_type| product_type.context_option_types = [create(:option_type_decorated, :with_date_option_type)]}
    end

    trait :with_rate_option_types do
      after(:create) {|product_type| product_type.rate_option_types = [create(:option_type_decorated, :with_date_option_type)]}
    end

  end
end