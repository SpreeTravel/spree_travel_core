FactoryGirl.define do
  factory :product_product_type, class: Spree::ProductType do
    sequence(:name) { |n| "product_type_##{n}" }
    sequence(:presentation){ |n| "Product Type ##{n}"}
    enabled true
  end
end