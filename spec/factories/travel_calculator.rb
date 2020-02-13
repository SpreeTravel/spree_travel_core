FactoryBot.define do
  factory :travel_calculator, class: Spree::TravelCalculator do
    name    { 'Spree::CalculatorProductType' }

    product_type
  end
end