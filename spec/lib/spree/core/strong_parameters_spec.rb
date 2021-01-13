require 'spec_helper'

class FakesController < ApplicationController
  include Spree::Core::ControllerHelpers::StrongParameters
end

describe Spree::Core::ControllerHelpers::StrongParameters, type: :controller do
  controller(FakesController) {}

  describe '#permitted_line_item_attributes' do
    it 'include paxe attributes' do
      checkout_attr = controller.permitted_checkout_attributes
      checkout_attr.last[checkout_attr.last.keys.last]
      paxes_attr = [:id, :variant_id, :quantity, :paxes, {:paxes_attributes=>[:id, :first_name, :last_name]}]
      expect(checkout_attr.last[checkout_attr.last.keys.last]).to eq paxes_attr
    end
  end
end
