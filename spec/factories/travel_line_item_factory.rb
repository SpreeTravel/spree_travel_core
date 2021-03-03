FactoryBot.define do
  factory :travel_line_item, class: Spree::LineItem do
    quantity { 1 }
    price    { BigDecimal('10.00') }
    currency { order.currency }

    order
    product
    variant { product.master }

    trait :with_context do
      association :context , factory: :context
    end

    trait :with_travel_product do
      association :product, factory: :travel_product
    end

    after(:create) do |line_item|
      create(:pax, line_item: line_item)
    end
  end
end