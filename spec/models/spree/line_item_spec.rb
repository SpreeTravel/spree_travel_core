require 'spec_helper'

describe Spree::LineItem do

  it 'haves a valid factory' do
    expect(build(:travel_line_item)).to be_valid
  end

end