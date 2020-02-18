require 'rails_helper'

RSpec.describe Spree::Admin::RatesController, type: :controller do

  describe '#index' do
    let(:product_type) { create(:product_type, :with_variant_option_types) }
    let(:product) { create(:travel_product, product_type: product_type) }
    let(:rate) { create(:rate, variant: product.variants.first) }

    it 'show the index of rates' do
      get :index, product_id: product.id
      expect(response.status).to eq(200)
    end
  end

  describe '#create' do

  end

  describe '#update' do

  end

  describe '#destroy' do

  end
end
