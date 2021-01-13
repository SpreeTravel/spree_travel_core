require 'spec_helper'

module Spree
  describe ProductsController, type: :controller do
      describe '#show' do
        let(:product_type) { create(:product_type, :with_variant_option_types) }
        let(:travel_product) { create(:travel_product, product_type: product_type) }
        let(:product) { create(:product) }

        it 'show the travel product' do
          get :show, params: { id: travel_product.slug, product_type: product_type }
          expect(response).to have_http_status(:success)
        end

        describe 'for a travel product' do
          describe 'without context params' do
            it 'should show flash message' do
              get :show, params: { id: travel_product.slug }
              expect(flash[:error]).to eq("You don't have access to this product")
            end

            it 'should redirect to root_path' do
              get :show, params: { id: travel_product.slug }
              expect(response).to have_http_status(:redirect)
            end
          end
        end
      end
    end
end
