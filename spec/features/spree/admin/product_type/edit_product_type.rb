require 'spec_helper'

describe "Spree Product Create View" , type: :feature do
  context 'as Admin user' do
    stub_authorization!

    before do
      @product_type = create(:product_type, :with_variant_option_types, :with_context_option_types, :with_rate_option_types)
      visit spree.admin_product_types_path
      click_link 'Edit'
      expect(page).to have_content('Editing Product Type')
    end

    context 'inside product_type editing page' do
      it 'should have Rate Option Types' do
        expect(page).to have_content('Rate Option Type')
        expect(page).to have_css('#product_type_rate_option_type_ids_field')
      end

      it 'should have Context Option Types' do
        expect(page).to have_content('Context Option Type')
        expect(page).to have_css('#product_type_context_option_type_ids_field')
      end

      it 'should have Variant Option Types' do
        expect(page).to have_content('Variant Option Type')
        expect(page).to have_css('#product_type_variant_option_type_ids_field')
      end
    end
  end
end
