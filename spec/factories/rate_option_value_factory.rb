FactoryBot.define do
  factory :rate_option_value, class: Spree::RateOptionValue do
    option_value  { create(:option_value)}
    rate          { create(:rate) }
    value         { 20 }
  end
end