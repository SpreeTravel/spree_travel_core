FactoryBot.define do
  factory :value, class: Spree::Value do
    pax { 1 }
    date { Date.today }
  end
end