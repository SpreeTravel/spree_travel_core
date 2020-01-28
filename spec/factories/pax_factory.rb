FactoryBot.define do
  factory :pax, class: Spree::Pax do
    first_name    { FFaker::Name.first_name }
    last_name     { FFaker::Name.last_name }
    sex           { 'male' }
    birth do
            from = 24.years.from_now.to_f
            to   = 25.years.from_now.to_f
            Time.at(from + rand * (to - from))
    end

    line_item
  end
end