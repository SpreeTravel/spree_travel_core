require 'spec_helper'

describe Spree::Product do
  it 'associates correctly with product type' do
    travel_prod = build(:travel_product)
    expect(travel_prod).to be_valid
    expect(travel_prod.product_type).not_to be_nil
  end

  it 'creates variants with each option type' do
    prod_type = create(:product_type_with_variant_option_types)
    puts prod_type.variant_option_types
    prod = create(:travel_product, product_type: prod_type)
    puts prod.product_type.variant_option_types
    puts prod.variants
    variant = prod.variants.first
    expect(variant.option_type).to be_equal(prod.variant_option_types.first)
  end
end