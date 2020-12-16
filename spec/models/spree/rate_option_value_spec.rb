require 'spec_helper'

describe Spree::RateOptionValue do
  it { expect(Spree::RateOptionValue.new.respond_to?(:rate)).to eq true }
  it { expect(Spree::RateOptionValue.new.respond_to?(:option_value)).to eq true }
  it { expect(Spree::RateOptionValue.new.respond_to?(:prices)).to eq true }

  it 'is not valid without value' do
    # expect(build(:rate_option_value, value: nil)).not_to be_valid
  end

  describe 'When creating a preciable Rate Option Value' do
    let(:option_type) { create(:option_type_decorated, preciable:true) }
    let(:option_value) { create(:option_value, option_type: option_type ) }
    let!(:rate) { create(:rate) }

    it 'should create a Spree::Price record related to the RateOptionValue' do
      expect {
        create(:rate_option_value, option_value: option_value, rate: rate)
      }.to change(Spree::Price, :count).by(1)
    end
  end

  describe 'rate_option_value' do
    let(:option_type) { create(:option_type_decorated, preciable:true) }
    let(:option_value) { create(:option_value, option_type: option_type ) }
    let(:rate_option_value) { create(:rate_option_value, option_value: option_value)}

    it 'should returns a Spree::Price' do
      expect(rate_option_value.price_in("USD").class).to eq(Spree::Price)
    end

    it 'should return price amount' do
      expect(rate_option_value.amount_in("USD").to_i).to eq(20)
    end
  end

end

