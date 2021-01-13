require 'spec_helper'

class FakesController < ApplicationController
  include Spree::Core::ControllerHelpers::Search
end

class Spree::Core::Search::SpreeTravelProductTypeBase
#  This class is mend to be defined on specific product_type gem
  attr_accessor :current_user
  attr_accessor :current_currency

  def initialize(params);end
end

describe Spree::Core::ControllerHelpers::Search, type: :controller do
  controller(FakesController) {}

  describe '#build_searcher for SpreeProducts' do
    it 'returns Spree::Core::Search::Base instance' do
      allow(controller).to receive_messages(try_spree_current_user: create(:user),
                                            current_currency: 'USD')
      expect(controller.build_searcher({}).class).to eq Spree::Core::Search::Base
    end
  end

  describe '#build_searcher for SpreeTravelProducts' do
    let(:product_type) { create(:product_type, name: 'product_type') }

    it 'returns Spree::Core::Search::Base instance' do
      allow(controller).to receive_messages(try_spree_current_user: create(:user),
                                            current_currency: 'USD')
      expect(controller.build_searcher({product_type: product_type.name}).class).to eq Spree::Core::Search::SpreeTravelProductTypeBase
    end
  end
end
