require 'spec_helper'

describe Spree::Rate do

  it { expect(Spree::Rate.new.respond_to?(:variant)).to eq true }
  it { expect(Spree::Rate.new.respond_to?(:option_values)).to eq true }
  it { expect(Spree::Rate.new.respond_to?(:line_items)).to eq true }

  it 'has a valid factory' do
    expect(build(:rate)).to be_valid
  end

  it 'respond to the attributes' do
    product_type = create(:product_type, :with_variant_option_types)
    product = create(:travel_product, product_type: product_type)
    rate = create(:rate, variant: product.variants.first)

    expect(rate).to respond_to(:start_date)
    expect(rate).to respond_to(:end_date)
    expect(rate).to respond_to(:plan)
    expect(rate).to respond_to(:simple)
    expect(rate).to respond_to(:double)
    expect(rate).to respond_to(:triple)
    expect(rate).to respond_to(:first_child)
    expect(rate).to respond_to(:second_child)
    expect(rate).to respond_to(:one_adult)
    expect(rate).to respond_to(:one_child)
  end

end