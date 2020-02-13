require 'spec_helper'

describe Spree::TravelCalculator do
  it { expect(Spree::TravelCalculator.new.respond_to?(:product_type)).to eq true }

  it 'validate name' do
    expect(build(:travel_calculator, name: nil)).not_to be_valid
  end

end