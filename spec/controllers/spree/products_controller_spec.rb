# require 'spec_helper'

# module Spree
#   describe ProductsController, type: :controller do
#       describe '#show' do
#         let(:product_type) { create(:product_type, :with_variant_option_types) }
#         let(:travel_product) { create(:travel_product, product_type: product_type) }
#         let(:product) { create(:product) }

#         describe 'for a travel product' do

#           describe 'with context params' do
#             before do
#               allow_any_instance_of(Spree::ParamsSanitize).to receive(:call).and_return({})
#             end

#             it 'show the travel product' do
#               expect(Spree::Context).to receive(:build_from_params).and_return(Context.new)

#               get :show, params: { id: travel_product.slug, product_type: product_type }

#               expect(response).to have_http_status(:success)
#             end
#           end

#           describe 'without context params' do
#             it 'should show flash message' do
#               get :show, params: { id: travel_product.slug }
#               expect(flash[:error]).to eq("You don't have access to this product")
#             end

#             it 'should redirect to root_path' do
#               get :show, params: { id: travel_product.slug }
#               expect(response).to have_http_status(:redirect)
#             end
#           end
#         end
#       end
#     end
# end
