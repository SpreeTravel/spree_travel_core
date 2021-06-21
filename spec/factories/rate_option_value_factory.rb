FactoryBot.define do
  factory :rate_option_value, class: Spree::RateOptionValue do
    rate
    option_value
  end
end