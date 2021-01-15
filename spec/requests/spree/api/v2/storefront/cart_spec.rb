require 'spec_helper'


class Spree::CalculatorProductType
  def initialize(context:, product:, variant:, options:)
  end
  def calculate_price
    [{rate: 1, price: '$20.00' }]
  end
end

describe 'API V2 Storefront Cart Spec', type: :request do
  let(:product_type) { create(:product_type, :with_context_option_types) }
  let(:product) { create(:travel_product, product_type: product_type) }
  let(:context_params) { params_for_dynamic_attribute(product) }
  let(:default_currency) { 'USD' }
  let(:store) { create(:store, default_currency: default_currency) }
  let(:currency) { store.default_currency }
  let(:user)  { create(:user) }
  let(:order) { create(:order, user: user, store: store, currency: currency) }
  let(:variant) { create(:variant, product: product) }
  let(:rate) { create(:rate, variant: variant) }

  include_context 'API v2 tokens'

  describe 'cart#add_item' do
    let(:options) { {} }
    let(:params) { { variant_id: variant.id,
                     quantity: 5,
                     rate_id: rate.id,
                     options: options, include: 'variants' }.merge(context_params) }
    let(:execute) { post '/api/v2/storefront/cart/add_item', params: params, headers: headers }

    before do
      Spree::PermittedAttributes.line_item_attributes << :cost_price
    end

    shared_examples 'adds item' do
      before { execute }

      it_behaves_like 'returns 200 HTTP status'
      it_behaves_like 'returns valid cart JSON'

      it 'with success' do
        expect(order.line_items.count).to eq(2)
        expect(order.line_items.last.variant).to eq(variant)
        expect(order.line_items.last.quantity).to eq(5)
        expect(json_response['included']).to include(have_type('variant').and(have_id(variant.id.to_s)))
      end
    end

    context 'as a signed in user' do
      include_context 'creates order with line item'

      context 'with existing order' do
        it_behaves_like 'adds item'
      end
    end
  end
end
