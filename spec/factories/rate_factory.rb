FactoryBot.define do
  factory :rate, class: Spree::Rate do
    association :variant, factory: :travel_variant

    after(:build) do |rate|
      rate.rate_option_values << build(:rate_option_value, rate: rate)
    end
  end
end