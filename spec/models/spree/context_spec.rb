require 'spec_helper'

describe Spree::Context do

  it 'haves a valid factory' do
    expect(build(:context)).to be_valid
  end

end