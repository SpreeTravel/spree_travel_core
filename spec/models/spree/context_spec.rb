require 'spec_helper'

describe Spree::Context do

  it { expect(Spree::Context.new.respond_to?(:line_items)).to eq true }
  it { expect(Spree::Context.new.respond_to?(:option_values)).to eq true }

  it 'has a valid factory' do
    expect(build(:context)).to be_valid
  end

  describe 'build from params' do
    before do
      @product_type   = create(:product_type, :with_context_option_types, name: 'car', presentation: 'Car')
      @product         = create(:travel_product, product_type: @product_type)
      @context_params = params_for_dynamic_attribute(@product)
    end

    it 'temporal' do
      context = Spree::Context.build_from_params(@context_params, temporal: true)

      expect(context.get_temporal_option_value(@product.context_option_types.first.name))
          .to eq(@product.context_option_types.first.option_values.first.name)
    end

    it 'persisted' do
      context = Spree::Context.build_from_params(@context_params, temporal: false)

      expect(context.get_persisted_option_value(@product.context_option_types.first.name))
          .to eq(@product.context_option_types.first.option_values.first.name)
    end
  end

end