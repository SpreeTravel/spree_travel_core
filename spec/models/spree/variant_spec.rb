require 'spec_helper'

describe Spree::Variant do

  it { expect(Spree::Variant.new.respond_to?(:rates)).to eq true }
  it { expect(Spree::Variant.new.respond_to?(:calculator)).to eq true } #not sure if this is usefull
  it { expect(Spree::Variant.new.respond_to?(:product_type)).to eq true }

  it 'has a valid factory' do
    expect(build(:travel_variant)).to be_valid
  end

  context 'for rendering Context Option Types presentation in the show view' do
    before do
      product_type    = create(:product_type, :with_variant_option_types)
      travel_product  = create(:travel_product, product_type: product_type)
      @option_value    = create(:option_value, option_type: product_type.variant_option_types.first)
      @travel_variant = create(:travel_variant, product: travel_product, option_values: [@option_value])
    end

    it 'should return an array of string' do
      expect(@travel_variant.option_values_presentation).to eq [@option_value.presentation]
    end
  end


end