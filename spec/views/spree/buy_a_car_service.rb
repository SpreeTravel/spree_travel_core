require 'spec_helper'

describe "Spree Home View" do
  context 'as an anonymous user' do
    #spree helper to enter as admin
    before(:each) do
      product_type = create(:product_type, name: 'car', presentation: 'Car')
      create(:travel_product, name: 'Fiat UNO Way', product_type: product_type)


      visit spree.home_path
    end

    it 'put a car into the shopping cart making a search' do
      within("#{}cart_form") do
         expect(page).to have_content('Add to Cart')
      end
    end
  end
end