require 'spec_helper'

describe Spree::Prototype do
  it { expect(Spree::Prototype.new.respond_to?(:product_type)).to eq true }
end