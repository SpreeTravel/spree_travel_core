require 'spec_helper'

describe Spree::ContextOptionValue do
  it { expect(Spree::ContextOptionValue.new.respond_to?(:context)).to eq true }
  it { expect(Spree::ContextOptionValue.new.respond_to?(:option_value)).to eq true }
end