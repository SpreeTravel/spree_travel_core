FactoryBot.define do
  factory :travel_product, class: Spree::Product do
    sequence(:name) { |n| "Product ##{n} - #{Kernel.rand(9999)}" }
    price                 { 20 }
    cost_price            { 10 }
    sku                   { "ABC-#{Kernel.rand(9999)}" }
    available_on          { Time.now }
    deleted_at            { nil }
    shipping_category     { |r| Spree::ShippingCategory.first || r.association(:shipping_category) }

    association :product_type, factory: :product_type

  end
end