FactoryGirl.define do
  factory :product_product_type, class: Spree::ProductType do
    sequence(:name) { |n| "product_type_##{n}" }
    sequence(:presentation){ |n| "Product Type ##{n}"}
    enabled true

    # factory :product_type_with_variant_option_types do
    #   association :variant_option_types, factory: :option_type_decorated
    # end

  end
end