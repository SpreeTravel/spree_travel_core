require 'spec_helper'

module Spree
  module Admin
    describe RatesController, type: :controller do
      stub_authorization!

      before do
        @product_type = create(:product_type, :with_rate_option_types, name: 'product_type')
        @product = create(:travel_product, product_type: @product_type)
        @variant = create(:travel_variant, product: @product)
      end

      describe '#index' do
        let(:rate) { create(:rate, variant: @variant) }

        it 'show the index of rates' do
          get :index, params: { product_id: @product.slug }

          expect(response).to have_http_status(:success)
        end
      end

      describe '#create' do
        let(:option_value_param_key) {@product_type.name + '_' +@product_type.rate_option_types.first.name}

        it 'create a new rate' do
          post :create, params: { 'rate'=>{"variant_id"=>@variant.id,
                                           option_value_param_key=> '2021-05-05'},
                                  'product_id'=> @variant.product.slug }

          assert_equal '2021-05-05', Spree::Rate.last.persisted_option_value(@product.rate_option_types.first).to_s
        end

        it 'do not save the record' do
          post :create, params: { 'rate'=>{"variant_id"=>@variant.id},
                                  'product_id'=> @variant.product.slug }

          flash[:error].should == "There was a problem creating the rate"
          expect(response.status).to eq(200)
        end
      end

      describe '#update' do
        let(:option_value_param_key) {@product_type.name + '_' +@product_type.rate_option_types.first.name}

        let(:rate) { create(:rate, :with_rate_option_values, variant: @variant) }
        let(:option_value) { create(:option_value, option_type: @product_type.rate_option_types.first) }
        let(:rate_option_value) { create(:rate_option_value, rate: rate, option_value: option_value) }
        let(:value) { create(:value, valuable: rate_option_value, date: '2021-05-05') }

        it 'update the rate with the new value' do
          post :update, params: {'product_id'=> @product.slug,
                                 'id'=> rate.id,
                                 'rate'=>{"variant_id"=>@variant.id,
                                 option_value_param_key =>'2021-05-10'}
          }

          value = rate.persisted_option_value(@product.rate_option_types.first)

          assert_equal '2021-05-10', value.to_s
        end
      end
    end
  end
end
