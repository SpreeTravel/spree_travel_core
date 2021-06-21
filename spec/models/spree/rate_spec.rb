require 'spec_helper'

describe Spree::Rate do
  it { expect(Spree::Rate.new.respond_to?(:variant)).to eq true }
  it { expect(Spree::Rate.new.respond_to?(:rate_option_values)).to eq true }
  it { expect(Spree::Rate.new.respond_to?(:line_items)).to eq true }

  it 'has a valid factory' do
    expect(build(:rate, :with_rate_option_values)).to be_valid
  end
end