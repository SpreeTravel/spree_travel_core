FactoryBot.define do
  factory :rate, class: Spree::Rate do
    association :variant, factory: :travel_variant
  end
end