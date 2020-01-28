FactoryBot.define do
  factory :travel_line_item, class: Spree::LineItem do
    order
    quantity { 1 }
    price    { BigDecimal('10.00') }
    currency { order.currency }
    transient do
      association :product
    end
    variant { product.master }
    context  { build_stubbed(:context) }

    after(:create) do |line_item|
      create(:pax, line_item: line_item)
    end
  end
end