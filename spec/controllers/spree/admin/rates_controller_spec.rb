require 'spec_helper'

module Spree
  module Admin
    describe RatesController, type: :controller do
      stub_authorization!

      describe '#index' do
        let(:product_type) { create(:product_type, :with_variant_option_types) }
        let(:product) { create(:travel_product, product_type: product_type) }
        let(:rate) { create(:rate, variant: product.variants.first) }

        it 'show the index of rates' do
          get :index, params: { product_id: product.slug }
          expect(response).to have_http_status(:success)
        end
      end

      describe '#create' do

      end

      describe '#update' do

      end

      describe '#destroy' do

      end
    end
  end
end
