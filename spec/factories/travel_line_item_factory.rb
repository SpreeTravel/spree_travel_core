FactoryBot.define do
  factory :travel_line_item, class: Spree::LineItem do
    quantity          { 0 }
    price             { BigDecimal.new('10.00') }
    order
    variant           { product.master }
    pax               { create(:male_pax) }
    context           { create(:context) }

    ignore do
      association :travel_product
    end
  end
end