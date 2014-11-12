FactoryGirl.define do
  factory :product_type, class: Spree::ProductType do
    sequence(:name) { |n| "product_type_##{n}" }
    sequence(:presentation){ |n| "Product Type ##{n}"}
    enabled true
    factory :product_type_with_variant_option_types do
      after(:create) {|product_type| product_type.variant_option_types = [create(:option_type_decorated)]}
    end
  end
end