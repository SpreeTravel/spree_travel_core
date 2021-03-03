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
        let(:variant) { create(:travel_variant) }

        it 'create a new rate' do
          allow_any_instance_of(Spree::Rate).to receive(:set_persisted_option_values)
          allow_any_instance_of(Spree::Rate).to receive(:save).and_return(true)

          post :create, params: { 'rate'=>{"variant_id"=>variant.id},
                                  'product_id'=> variant.product.slug }

          expect(response.status).to eq(302)
        end

        it 'do not save the record' do
          allow_any_instance_of(Spree::Rate).to receive(:set_persisted_option_values)
          allow_any_instance_of(Spree::Rate).to receive(:save).and_return(false)

          post :create, params: { 'rate'=>{"variant_id"=>variant.id},
                                  'product_id'=> variant.product.slug }

          expect(response.status).to eq(200)
        end
      end

      describe '#update' do
        let(:product_type) { create(:product_type, :with_rate_option_types_price) }
        let(:variant) { create(:travel_variant) }
        let(:product) { create(:travel_product, product_type: product_type) }
        let(:rate) { create(:rate, variant: variant) }
        let(:option_value) { create(:option_value, option_type: product_type.rate_option_types.first) }
        let!(:rate_option_value) { create(:rate_option_value, rate: rate, option_value: option_value) }

        it 'update the rate with the new value' do
          post :update, params: {'product_id'=> product.slug,
                                 'id'=> rate.id,
                                 'rate'=>{"variant_id"=>variant.id},
                                 product_type.rate_option_types.first.name => 100 }

          value = rate.get_persisted_option_value(product.rate_option_types.first.name)

          assert_equal '$100.00', value.format
        end
      end
    end
  end
end
