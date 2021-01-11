require 'spec_helper'

describe Spree::LineItem do

  it { expect(Spree::LineItem.new.respond_to?(:paxes)).to eq true }
  it { expect(Spree::LineItem.new.respond_to?(:context)).to eq true }
  it { expect(Spree::LineItem.new.respond_to?(:rate)).to eq true }

  it 'has a valid factory' do
    allow_any_instance_of(Spree::Stock::Quantifier).to receive(:can_supply?).and_return(true)

    expect( build(:travel_line_item) ).to be_valid
  end

  describe 'when coping price to the instance' do
    let(:product_type) { build(:product_type) }
    let(:travel_product) { build(:travel_product) }

    it 'should use the product_type calculator to compute it' do
      allow_any_instance_of(Spree::Variant).to receive(:product_type).and_return(product_type)
      allow_any_instance_of(Spree::Variant).to receive(:cost_price).and_return(5)
      allow_any_instance_of(Spree::Variant).to receive(:currency).and_return('USD')
      allow_any_instance_of(Spree::Variant).to receive(:product).and_return(travel_product)
      allow_any_instance_of(Spree::Stock::Quantifier).to receive(:can_supply?).and_return(true)

      allow_any_instance_of(Spree::LineItem).to receive(:rate).and_return(build_stubbed(:rate, id: 1))
      expect(travel_product).to receive(:calculate_price).and_return([{rate: 1, price: '$20.00' }])

      line_item = create(:travel_line_item, :with_travel_product)

      expect(line_item.price).to eq 20
      expect(line_item.cost_price).to eq 5
      expect(line_item.currency).to eq 'USD'
    end
  end

  describe 'when updating context attribute' do
    before do
      context_attr = {'option_type_1'=> 20, 'product_type'=> 'any'}
      @line_item_attrs = { context_attributes: context_attr}
    end

    it 'should call set_persisted_option_values' do
      line_item = create(:travel_line_item, :with_context)

      expect_any_instance_of(Spree::Context).to receive(:set_persisted_option_values)
                                            .with({'option_type_1'=> 20, 'product_type'=> 'any', line_item_id: line_item.id})

      line_item.update(@line_item_attrs)
    end
  end
end