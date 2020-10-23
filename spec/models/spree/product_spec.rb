require 'spec_helper'

describe Spree::Product do

  it { expect(Spree::Product.new.respond_to?(:product_type)).to eq true }
  it { expect(Spree::Product.new.respond_to?(:rates)).to eq true }

  it 'associates correctly with product type' do
    travel_prod = build(:travel_product)
    expect(travel_prod).to be_valid
    expect(travel_prod.product_type).not_to be_nil
  end
end