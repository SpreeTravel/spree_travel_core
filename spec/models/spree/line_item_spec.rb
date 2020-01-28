require 'spec_helper'

describe Spree::LineItem do

  it { expect(Spree::LineItem.new.respond_to?(:paxes)).to eq true }
  it { expect(Spree::LineItem.new.respond_to?(:context)).to eq true }
  it { expect(Spree::LineItem.new.respond_to?(:rate)).to eq true }

  it 'has a valid factory' do
    # expect(build(:travel_line_item)).to be_valid
  end

  describe 'copy price from the ' do
    before do
      @travel_product = create(:travel_product)
    end

    it 'should copy the price into the instance' do
      allow_any_instance_of(Spree::Variant).to receive(:product).and_return(@travel_product)
      allow_any_instance_of(Spree::Variant).to receive(:cost_price).and_return(5)
      allow_any_instance_of(Spree::Variant).to receive(:currency).and_return('USD')

      allow_any_instance_of(Spree::LineItem).to receive(:rate).and_return(build_stubbed(:rate, id: 1))
      expect(@travel_product).to receive(:calculate_price).and_return([{rate: 1, price: 20 }])

      # @line_item.copy_price
      @line_item = create(:travel_line_item)


      expect(@line_item.price).to eq 20
      expect(@line_item.cost_price).to eq 5
      expect(@line_item.currency).to eq 'USD'

    end

  end


end