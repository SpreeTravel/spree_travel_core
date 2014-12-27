require 'spec_helper'

describe Spree::Rate do

  it 'haves a valid factory' do
    expect(build(:rate)).to be_valid
  end

end