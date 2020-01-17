FactoryBot.define do
  factory :product_type, class: Spree::ProductType do
    sequence(:name)         { |n| "product_type_##{n}" }
    sequence(:presentation) { |n| "Product Type ##{n}"}
    enabled                       { true }

    trait :with_variant_option_types do
      after(:create) {|product_type| product_type.variant_option_types = [create(:selection_option_type_with_values)]}
    end

    trait :with_context_option_types do
      after(:create) {|product_type| product_type.context_option_types = [create(:option_type_decorated, :with_date_option_type)]}
      # after(:create) {|product_type| product_type.context_option_types = [create(:selection_option_type_with_values)]}
    end

  end
end