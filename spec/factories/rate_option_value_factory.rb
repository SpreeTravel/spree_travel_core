FactoryBot.define do
  factory :rate_option_value, class: Spree::RateOptionValue do
    value         { 20 }

    rate
    option_value
  end
end