require 'spec_helper'

describe "Spree Product Create View" , type: :feature do
  context 'as Admin user' do
    stub_authorization!

    before do
      @shipping_category  = create(:shipping_category)
      @product_type       = create(:product_type)
      @travel_calculator  = create(:travel_calculator, product_type: @product_type)
      visit spree.admin_products_path
      click_link 'admin_new_product'
      within('#new_product') do
        expect(page).to have_content('SKU')
      end
    end

    context 'creating a new travel product' do
      it 'allows an admin to create a new option type' do
        fill_in 'product_name', with: 'Travel Product 1'
        fill_in 'product_price', with: '10'

        select @shipping_category.name, from: 'product_shipping_category_id'
        select @product_type.presentation, from: 'product_product_type_id'
        select @travel_calculator.name, from: 'product_calculator_id'

        click_button 'Create'
        expect(page).to have_content('successfully created!')
        expect(page).to have_content('Rates')
      end
    end
  end
end
