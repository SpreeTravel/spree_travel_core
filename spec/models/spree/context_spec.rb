require 'spec_helper'

describe Spree::Context do
  it { expect(Spree::Context.new.respond_to?(:line_items)).to eq true }
  it { expect(Spree::Context.new.respond_to?(:context_option_values)).to eq true }

  it 'has a valid factory' do
    expect(build(:context)).to be_valid
  end

  describe 'when no temporal option is provided' do
    it 'raises a StandarError' do
      expect{
        Spree::Context.build_from_params({})
      }.to raise_error(StandardError, 'You must be explicit about temporal or not')
    end
  end

  describe 'build from params' do
    let!(:option_type) { create(:option_type_decorated, :with_date_option_type, name: 'date_option_type') }
    let(:senitized_params) { { "date_option_type" => Date.today } }

    describe 'for TemporalDynamicAttribute' do
      before do
        @context = Spree::Context.build_from_params(senitized_params, temporal: true)
      end

      it 'store the params in the temporal variable' do
        assert_equal @context.temporal, senitized_params
      end
    end

    describe 'for PersistedDynamicAttribute' do
      it 'creates a Spree::Context' do
        expect {
          Spree::Context.build_from_params(senitized_params, temporal: false)
        }.to change(Spree::Context, :count).by(1)
      end

      it 'creates a Spree::Value' do
        expect {
          Spree::Context.build_from_params(senitized_params, temporal: false)
        }.to change(Spree::Value, :count).by(1)
      end
    end
  end
end