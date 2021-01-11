FactoryBot.define do
  factory :travel_variant, class: Spree::Variant, parent: :variant do
    sequence(:sku, 'a'){ |n| "travel_variant_#{n}" }

    association :product, factory: :travel_product
    option_values { [create(:option_value)] }

  end
end