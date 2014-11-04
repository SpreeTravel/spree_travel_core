require 'spec_helper'

describe Spree::Pax do

  it 'haves a valid default factory' do
    expect(build(:male_pax)).to be_valid
  end

  it 'is not valid without a first name' do
    expect(build(:male_pax, first_name: nil)).not_to be_valid
  end

  it 'is not valid without a last name' do
    expect(build(:male_pax, last_name: nil)).not_to be_valid
  end

  it 'is not valid without a sex' do
    expect(build(:male_pax, sex: nil)).not_to be_valid
  end

  it 'only accept sex values for male and female' do
    expect(build(:male_pax)).to be_valid
    expect(build(:female_pax)).to be_valid
    expect(build(:pax, sex: "other")).not_to be_valid
  end
end