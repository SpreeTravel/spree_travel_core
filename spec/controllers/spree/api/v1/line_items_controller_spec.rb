require 'spec_helper'

module Spree
  PermittedAttributes.module_eval do
    mattr_writer :line_item_attributes
  end

  # unless PermittedAttributes.line_item_attributes.include?(:some_option)
  #   PermittedAttributes.line_item_attributes += [:some_option]
  # end

  # This should go in an initializer
  # Spree::Api::V1::LineItemsController.line_item_options += [:some_option]

  # describe Api::V1::LineItemsController, type: :controller do
  #   render_views
  #
  #   let!(:order) { create(:order_with_line_items, line_items_count: 1) }
  #
  #   let(:product) { create(:product) }
  #   let(:attributes) { [:id, :quantity, :price, :variant, :total, :display_amount, :single_display_amount] }
  #   let(:resource_scoping) { { order_id: order.to_param } }
  #   let(:admin_role) { create(:admin_role) }
  #
  #   before do
  #     stub_authentication!
  #   end
  #
  #   context 'as the order owner' do
  #     before do
  #       allow_any_instance_of(Order).to receive_messages user: current_api_user
  #     end
  #
  #     it 'can add a new line item to an existing order' do
  #       api_post :create, line_item: { variant_id: product.master.to_param, quantity: 1 }
  #       expect(response.status).to eq(201)
  #       expect(json_response).to have_attributes(attributes)
  #       expect(json_response['variant']['name']).not_to be_blank
  #     end
  #
  #     it 'can add a new line item to an existing order with options' do
  #       expect_any_instance_of(LineItem).to receive(:some_option=).with('foo')
  #       api_post :create,
  #                line_item: {
  #                  variant_id: product.master.to_param,
  #                  quantity: 1,
  #                  options: { some_option: 'foo' }
  #                }
  #       expect(response.status).to eq(201)
  #     end
  #
  #     it 'default quantity to 1 if none is given' do
  #       api_post :create, line_item: { variant_id: product.master.to_param }
  #       expect(response.status).to eq(201)
  #       expect(json_response).to have_attributes(attributes)
  #       expect(json_response[:quantity]).to eq 1
  #     end
  #
  #     it "increases a line item's quantity if it exists already" do
  #       order.line_items.create(variant_id: product.master.id, quantity: 10)
  #       api_post :create, line_item: { variant_id: product.master.to_param, quantity: 1 }
  #       expect(response.status).to eq(201)
  #       order.reload
  #       expect(order.line_items.count).to eq(2) # 1 original due to factory, + 1 in this test
  #       expect(json_response).to have_attributes(attributes)
  #       expect(json_response['quantity']).to eq(11)
  #     end
  #
  #     it 'can update a line item on the order' do
  #       line_item = order.line_items.first
  #       api_put :update, id: line_item.id, line_item: { quantity: 101 }
  #       expect(response.status).to eq(200)
  #       order.reload
  #       expect(order.total).to eq(1010) # 10 original due to factory, + 1000 in this test
  #       expect(json_response).to have_attributes(attributes)
  #       expect(json_response['quantity']).to eq(101)
  #     end
  #
  #     it "can update a line item's options on the order" do
  #       expect_any_instance_of(LineItem).to receive(:some_option=).with('foo')
  #       line_item = order.line_items.first
  #       api_put :update,
  #               id: line_item.id,
  #               line_item: { quantity: 1, options: { some_option: 'foo' } }
  #       expect(response.status).to eq(200)
  #     end
  #
  #     it 'can delete a line item on the order' do
  #       line_item = order.line_items.first
  #       api_delete :destroy, id: line_item.id
  #       expect(response.status).to eq(204)
  #       order.reload
  #       expect(order.line_items.count).to eq(0) # 1 original due to factory, - 1 in this test
  #       expect { line_item.reload }.to raise_error(ActiveRecord::RecordNotFound)
  #     end
  #
  #     context 'order contents changed after shipments were created' do
  #       let!(:order) { create(:order) }
  #       let!(:line_item) { Spree::Cart::AddItem.call(order: order, variant: product.master).value }
  #
  #       before { order.create_proposed_shipments }
  #
  #       it 'clear out shipments on create' do
  #         expect(order.reload.shipments).not_to be_empty
  #         api_post :create, line_item: { variant_id: product.master.to_param, quantity: 1 }
  #         expect(order.reload.shipments).to be_empty
  #       end
  #
  #       it 'clear out shipments on update' do
  #         expect(order.reload.shipments).not_to be_empty
  #         api_put :update, id: line_item.id, line_item: { quantity: 1000 }
  #         expect(order.reload.shipments).to be_empty
  #       end
  #
  #       it 'clear out shipments on delete' do
  #         expect(order.reload.shipments).not_to be_empty
  #         api_delete :destroy, id: line_item.id
  #         expect(order.reload.shipments).to be_empty
  #       end
  #
  #       context 'order is completed' do
  #         before do
  #           current_api_user.spree_roles << admin_role
  #           order.reload
  #           allow(order).to receive_messages completed?: true
  #           allow(Order).to receive_message_chain :includes, find_by!: order
  #         end
  #
  #         it "doesn't destroy shipments or restart checkout flow" do
  #           expect(order.reload.shipments).not_to be_empty
  #           api_post :create, line_item: { variant_id: product.master.to_param, quantity: 1 }
  #           expect(order.reload.shipments).not_to be_empty
  #         end
  #
  #         context 'deleting line items' do
  #           let!(:shipments) { order.shipments.load }
  #
  #           it 'restocks product after line item removal' do
  #             line_item = order.line_items.first
  #             variant = line_item.variant
  #             expect do
  #               api_delete :destroy, id: line_item.id
  #             end.to change { variant.total_on_hand }.by(line_item.quantity)
  #
  #             expect(response.status).to eq(204)
  #             order.reload
  #             expect(order.line_items.count).to eq(0)
  #           end
  #
  #           it 'calls `restock` on proper stock location' do
  #             expect(shipments.first.stock_location).to receive(:restock)
  #             api_delete :destroy, id: line_item.id
  #           end
  #         end
  #       end
  #     end
  #   end
  # end
end
