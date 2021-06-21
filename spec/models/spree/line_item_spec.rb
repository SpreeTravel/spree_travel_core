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
    let(:product_type) { build_stubbed(:product_type) }
    let(:variant) { create(:travel_variant) }

    it 'should use the product_type calculator to compute it' do
      allow_any_instance_of(Spree::Variant).to receive(:product_type).and_return(product_type)
      expect(variant).to receive(:calculate_price)
      expect(variant).to receive(:context_price).and_return(20)

      line_item = create(:travel_line_item, variant: variant)

      expect(line_item.price).to eq 20
      expect(line_item.cost_price).to eq 17.00
      expect(line_item.currency).to eq 'USD'
    end
  end

  describe 'when updating context attributes in the order' do
    let!(:line_item) { create(:travel_line_item, :with_context) }

    describe 'for a' do
      describe 'select option_type' do
        let!(:option_type) { create(:option_type, name: 'pickup_destination') }
        let!(:context_option_value) { create(:context_option_value, context: line_item.context, option_value_id: nil) }
        let(:option_value) { create(:option_value) }

        before do
          @line_item_attrs = { context_attributes: {"pickup_destination"=>option_value.id} }
          allow_any_instance_of(Spree::Context).to receive(:find_existing_option_value).and_return(context_option_value)
        end

        it 'should save the new value' do
          line_item.update(@line_item_attrs)

          assert_equal option_value.id, context_option_value.option_value_id
        end
      end

      describe 'date option_type' do
        let!(:option_type) { create(:option_type_decorated, name: 'pickup_date', attr_type: 'date') }
        let!(:option_value) { create(:option_value, option_type: option_type, name: 'date', presentation: 'Date') }
        let!(:context_option_value) { create(:context_option_value, context: line_item.context, option_value_id: option_value) }
        let!(:value) { create(:value, valuable: context_option_value) }

        before do
          @line_item_attrs = { context_attributes: { "pickup_date" => "2021-06-17" }}
        end

        it 'should save the new value' do
          line_item.update(@line_item_attrs)

          assert_equal '2021-06-17', line_item.context.persisted_option_value(option_type).to_s
        end
      end

      describe 'pax option_type' do
        let!(:option_type) { create(:option_type_decorated, name: 'pax', attr_type: 'pax') }
        let!(:context_option_value) { create(:context_option_value, context: line_item.context) }
        let!(:value) { create(:value, valuable: context_option_value) }

        before do
          @line_item_attrs = { context_attributes: { "pax" => "3" }}
        end

        it 'should save the new value' do
          line_item.update(@line_item_attrs)

          assert_equal 3, line_item.context.persisted_option_value(option_type)
        end
      end
    end
  end
end