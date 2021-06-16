require 'spec_helper'
require 'spree/testing_support/order_walkthrough'

describe Spree::Order, type: :model do
  let(:order) { Spree::Order.new }

  before { create(:store) }

  def assert_state_changed(order, from, to)
    state_change_exists = order.state_changes.where(previous_state: from, next_state: to).exists?
    assert state_change_exists, "Expected order to transition from #{from} to #{to}, but didn't."
  end

  context 'with default state machine' do
    let(:transitions) do
      [
          { address: :pax },
          { pax: :payment },
      ]
    end

    it 'has the following transitions' do
      transitions.each do |transition|
        result = Spree::Order.find_transition(from: transition.keys.first, to: transition.values.first)
        expect(result).not_to be_nil
      end
    end

    context '#checkout_steps' do
      context 'when confirmation not required' do
        before do
          allow(order).to receive_messages confirmation_required?: false
          allow(order).to receive_messages payment_required?: true
        end

        specify do
          expect(order.checkout_steps).to eq(%w(address pax payment complete))
        end
      end

      context 'when confirmation required' do
        before do
          allow(order).to receive_messages confirmation_required?: true
          allow(order).to receive_messages payment_required?: true
        end

        specify do
          expect(order.checkout_steps).to eq(%w(address pax payment confirm complete))
        end
      end

      context 'when payment not required' do
        before { allow(order).to receive_messages payment_required?: false }

        specify do
          expect(order.checkout_steps).to eq(%w(address pax complete))
        end
      end

      context 'when payment required' do
        before { allow(order).to receive_messages payment_required?: true }

        specify do
          expect(order.checkout_steps).to eq(%w(address pax payment complete))
        end
      end
    end

    context 'from address' do
      before do
        order.state = 'address'
        create(:shipment, order: order)
        order.email = 'user@example.com'
        order.save!
      end

      it 'transitions to pax' do
        allow(order).to receive_messages(ensure_available_shipping_rates: true)
        order.next!
        assert_state_changed(order, 'address', 'pax')
        expect(order.state).to eq('pax')
      end
    end

    context 'to pax' do
      context 'when order has default selected_shipping_rate_id' do
        let(:shipment) { create(:shipment, order: order) }
        let(:shipping_method) { create(:shipping_method) }
        let(:shipping_rate) do
          [
              Spree::ShippingRate.create!(shipping_method: shipping_method, cost: 10.00, shipment: shipment)
          ]
        end

        before do
          order.state = 'address'
          # shipment.selected_shipping_rate_id = shipping_rate.first.id
          order.email = 'user@example.com'
          order.save!

          # # allow(order).to receive(:has_available_payment)
          # allow(order).to receive(:create_proposed_shipments)
          # allow(order).to receive(:ensure_available_shipping_rates).and_return(true)
        end

        it 'invokes generate_paxes' do
          expect(order).to receive(:generate_paxes)
          order.next!
        end
      end
    end
  end

  context 'before transition to pax checkout state' do
    context 'for line_item with context' do
      let(:order) { create(:order) }
      let(:context) { create(:context) }
      let!(:line_item) { create(:line_item, order: order, context: context) }

      it 'should create pax' do
        allow_any_instance_of(Spree::Context).to receive(:adult).and_return('1')
        allow_any_instance_of(Spree::LineItem).to receive(:context).and_return(context)
        expect(order.generate_paxes.first.paxes.first).to be_an_instance_of(Spree::Pax)

      end
    end

    context 'for line_item without context' do
      let(:order) { create(:order) }
      let!(:line_item) { create(:line_item, order: order) }

      it 'should not create pax' do
        expect_any_instance_of(Spree::Context).not_to receive(:adult)
        expect(Spree::Pax).not_to receive(:new).with(line_item: line_item)
        expect_any_instance_of(Spree::LineItem).not_to receive(:reload)
        assert_nil order.generate_paxes
      end
    end
  end

  context 'empty!' do
    let(:order) { create :order_with_line_items, line_items_count: 1 }
    let(:promotion) { create :promotion, code: '10off' }
    let(:pax) {create :pax}

    before do
      order.line_items.first.paxes << pax
      promotion.orders << order
    end

    context 'completed order' do
      before do
        order.update_columns(state: 'complete', completed_at: Time.current)
      end

      it 'raises an exception' do
        expect { order.empty! }.to raise_error(RuntimeError, Spree.t(:cannot_empty_completed_order))
      end
    end

    context 'incomplete order' do
      before do
        expect(Spree::Pax.count).to eq 1
        order.empty!
      end

      it 'clears out line items, adjustments and update totals' do
        expect(Spree::Pax.count).to eq 0
        expect(order.line_items.count).to be_zero
        expect(order.adjustments.count).to be_zero
        expect(order.shipments.count).to be_zero
        expect(order.order_promotions.count).to be_zero
        expect(order.promo_total).to be_zero
        expect(order.item_total).to be_zero
        expect(order.empty!).to eq(order)
      end
    end
  end
end