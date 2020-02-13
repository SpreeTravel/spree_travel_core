require 'spec_helper'

describe Spree::BaseHelper, type: :helper do

  describe 'display travel price' do
    context 'for a product' do
      before do
        @variant = create(:travel_variant)
      end

      it 'should display the price' do
        expect_any_instance_of(Spree::Variant).to receive(:product).exactly(2).times.and_return(build(:travel_product))
        expect(Spree::Context).to receive(:build_from_params).and_return(build(:context))
        expect_any_instance_of(Spree::ProductDecorator).to receive(:calculate_price).and_return(true)
        display_travel_price(variant: @variant)
      end
    end
  end


end