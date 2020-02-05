require 'spec_helper'

describe Spree::DynamicAttribute do

  before do
    @object = Object.new
    @object.extend(Spree::DynamicAttribute)
    @object.extend(Spree::TemporalDynamicAttribute)
    @object.extend(Spree::PersistedDynamicAttribute)
  end

  describe 'when passing temporal true' do
    it 'should execute get_temporal_option_value' do
      expect(@object).to receive(:get_temporal_option_value)
      @object.get_mixed_option_value('start_date', {temporal: true})
    end
  end

  describe 'when passing temporal false' do
    it 'should execute get_persisted_option_value' do
      expect(@object).to receive(:get_persisted_option_value)
      @object.get_mixed_option_value('start_date', {temporal: false})
    end
  end

end