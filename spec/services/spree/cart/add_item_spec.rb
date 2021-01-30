require 'spec_helper'

module Spree
  describe Cart::AddItem do
    subject { described_class }

    let(:order) { create :order }
    let(:variant) { create :variant, price: 20 }
    let(:qty) { 1 }
    let(:context) { create(:context) }
    let(:rate) { create(:rate) }
    let(:execute) { subject.call(order: order,
                                 variant: variant,
                                 context: context,
                                 rate: rate,
                                 quantity: qty) }
    let(:value) { execute.value }
    let(:expected_line_item) { order.reload.line_items.first }

    context 'add travel line item to order' do
      it 'change by one and recalculate amount' do
        expect { execute }.to change { order.line_items.count }.by(1)
        expect(execute).to be_success
        expect(value).to eq expected_line_item
        expect(order.amount).to eq 20
      end
    end
  end
end
