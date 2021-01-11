require 'spec_helper'

describe Spree::Rate do

  it { expect(Spree::Rate.new.respond_to?(:variant)).to eq true }
  it { expect(Spree::Rate.new.respond_to?(:rate_option_values)).to eq true }
  it { expect(Spree::Rate.new.respond_to?(:line_items)).to eq true }

  it 'has a valid factory' do
    expect(build(:rate)).to be_valid
  end

  # it 'respond to the attributes' do
  #   create(:product_type, :with_rate_option_types)
  #   rate = Spree::Rate.new.date_option_type_a
  #   byebug
  #   # byebug
  #   expect(rate.respond_to?(:date_option_type_a)).to eq true
  # end

end