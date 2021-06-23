require 'spec_helper'

describe Spree::RateOptionValue do
  it { expect(Spree::RateOptionValue.new.respond_to?(:rate)).to eq true }
  it { expect(Spree::RateOptionValue.new.respond_to?(:option_value)).to eq true }
  it { expect(Spree::RateOptionValue.new.respond_to?(:prices)).to eq true }
  it { expect(Spree::RateOptionValue.new.respond_to?(:value)).to eq true }

  it 'is valid' do
    expect(build(:rate_option_value)).to be_valid
  end

  describe 'When creating a Rate Option Value' do
    describe 'for a price OptionType' do
      let(:option_type) { create(:option_type_decorated, :with_price_option_type) }
      let(:rate_option_value) {build(:rate_option_value,
                                     option_value: option_type.option_values.take) }

      it 'save the record' do
        expect {
          rate_option_value.persist(option_type, 20)
        }.to change(Spree::RateOptionValue, :count).by(1)
      end

      it 'store the value in Spree::Price' do
        expect {
          rate_option_value.persist(option_type, 20)
        }.to change(Spree::Price, :count).by(1)

      end

      describe 'when retrieve the value' do
        before do
          create(:zone_with_country, default_tax: true)

          rate_option_value.persist(option_type, 50)
          @price = rate_option_value.persisted(option_type)
        end

        it 'return the value' do
          assert_equal  50, @price.to_i
        end

        it 'is an instance of Money' do
          assert_instance_of Money, @price
        end
      end
    end

    describe 'for a date OptionType' do
      let(:option_type) { create(:option_type_decorated, :with_date_option_type) }
      let(:rate_option_value) {build(:rate_option_value,
                                     option_value: option_type.option_values.take)}

      it 'save the record' do
        expect {
          rate_option_value.persist(option_type, Date.today)
        }.to change(Spree::RateOptionValue, :count).by(1)
      end

      it 'store the value in Spree::Value' do
        expect {
          rate_option_value.persist(option_type, Date.today)
        }.to change(Spree::Value, :count).by(1)
      end

      describe 'when retrieve the value' do
        before do
          @date = Date.new(2021, 6, 12)
          rate_option_value.persist(option_type, @date)
          @pp = rate_option_value.persisted(option_type)
        end

        it 'return the value' do
          assert_equal @date , @pp
        end

        it 'is an instance of Money' do
          assert_instance_of Date, @pp
        end
      end
    end
  end
end

