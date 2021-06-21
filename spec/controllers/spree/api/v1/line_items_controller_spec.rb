require 'spec_helper'

class Spree::CalculatorProductType
  def initialize(context:, product:, variant:, options:)
  end
  def calculate_price
    [{rate: 1, price: '$20.00' }]
  end
end

module Spree
  PermittedAttributes.module_eval do
    mattr_writer :line_item_attributes
  end

  describe Api::V1::LineItemsController, type: :controller do
    render_views

    let!(:stock_location) {create(:stock_location)}

    let(:product) { create(:travel_product) }
    let(:rate) { create(:rate, :with_rate_option_values, variant: product.variants.first)}
    let(:order) { create(:order) }
    let(:context) { create(:context) }
    let(:line_item) { create(:line_item, product: product, rate: rate, order: order, quantity: 2) }

    let(:attributes) { [:id, :quantity, :price, :variant, :total, :display_amount, :single_display_amount] }
    let(:resource_scoping) { { order_id: order.to_param } }
    let(:admin_role) { create(:admin_role) }

    before do
      stub_authentication!
      PermittedAttributes.line_item_attributes += [:some_option]
      Spree::Api::V1::LineItemsController.line_item_options += [:some_option]
      line_item.variant.stock_items.first.update(backorderable: false)
      line_item.variant.stock_items.first.update(count_on_hand: 5)
    end

    after do
      Spree::PermittedAttributes.line_item_attributes.delete(:some_option)
      Spree::Api::V1::LineItemsController.line_item_options.shift
    end

    context 'as the order owner' do
      before do
        allow_any_instance_of(Order).to receive_messages user: current_api_user
      end

      it 'can add a new line item to an existing order' do
        api_post :create, line_item: { variant_id: product.master.to_param, quantity: 1, rate: rate, context: context }
        expect(response.status).to eq(201)
      end
    end
  end
end
