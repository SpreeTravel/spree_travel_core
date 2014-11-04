FactoryGirl.define do
  factory :pax, class: Spree::Pax do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    sex 'male'
    birth do
            from = 24.years.from_now.to_f
            to   = 25.years.from_now.to_f
            Time.at(from + rand * (to - from))
          end
  end

  #TODO Create factories for the two sexes
end