require 'spec_helper'

describe Spree::Context do

  it { expect(Spree::Context.new.respond_to?(:line_items)).to eq true }
  it { expect(Spree::Context.new.respond_to?(:context_option_values)).to eq true }

  it 'has a valid factory' do
    expect(build(:context)).to be_valid
  end

  describe 'build from params' do
    let(:product_type) { create(:product_type, :with_context_option_types, name: 'car', presentation: 'Car') }
    let(:product) { create(:travel_product, product_type: product_type) }
    let(:context_params) { params_for_dynamic_attribute(product) }

    it 'for temporal params' do
      context = Spree::Context.build_from_params(context_params, temporal: true)

      expect(context.get_temporal_option_value(product.context_option_types.first.name))
          .to eq(product.context_option_types.first.option_values.first.name)
    end

    it 'for persisted params' do
      context = Spree::Context.build_from_params(context_params, temporal: false)

      expect(context.persisted_option_value(product.context_option_types.first.name))
          .to eq(product.context_option_types.first.option_values.first.name)
    end

    it 'return nil if no product_type specified' do
      context_params.delete('product_type')
      context = Spree::Context.build_from_params(context_params, temporal: false)

      expect(context).to be(nil)
    end

    it 'raise Standard Error if temporal not specified' do
      expect { Spree::Context.build_from_params(context_params) }.to raise_error(StandardError, 'You must be explicit about temporal or not')
    end
  end
end