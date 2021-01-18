require 'spec_helper'

describe Spree::Rate do

  it { expect(Spree::Rate.new.respond_to?(:variant)).to eq true }
  it { expect(Spree::Rate.new.respond_to?(:rate_option_values)).to eq true }
  it { expect(Spree::Rate.new.respond_to?(:line_items)).to eq true }

  it 'has a valid factory' do
    expect(build(:rate)).to be_valid
  end

  it 'should respond to the start_date' do
    allow_any_instance_of(Spree::Rate).to receive(:get_persisted_option_value).with(:start_date)
    Spree::Rate.new.start_date
  end

  it 'should respond to the end_date' do
    allow_any_instance_of(Spree::Rate).to receive(:get_persisted_option_value).with(:end_date)
    Spree::Rate.new.end_date
  end

  # This method are from hotel gem, will stay here until migration
  %i[plan simple double triple first_child second_child one_adult].each do |method_name|
    it "should respond to the #{method_name}" do
      allow_any_instance_of(Spree::Rate).to receive(:get_persisted_option_value).with(method_name)
      Spree::Rate.new.send(method_name)
    end
  end
end