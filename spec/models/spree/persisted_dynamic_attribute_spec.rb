require 'spec_helper'

describe Spree::PersistedDynamicAttribute do

  before do
    @product_type = create(:product_type, name: 'any', presentation: 'Any')
  end

  describe 'with context' do
    describe 'when storing the context in the database' do
      before do
        @context = Spree::Context.new

        option_types = [
            {name: 'option_type_1', presentation: 'Option Type 1', attr_type: 'selection', travel: true, preciable: false},
            {name: 'option_type_2', presentation: 'Option Type 2', attr_type: 'date', travel: true, preciable: false},
            {name: 'option_type_3', presentation: 'Option Type 3', attr_type: 'integer', travel: true, preciable: false},
        ]

        option_types.each do |cot|
          option_type = create(:option_type_decorated, name: cot[:name],
                               presentation: cot[:presentation],
                               attr_type: cot[:attr_type],
                               travel: cot[:travel],
                               preciable: cot[:preciable])
          @product_type.context_option_types << option_type
        end

        option_type = Spree::OptionType.find_by(name: 'option_type_1')
        option_value = create(:option_value,
                              name: 'option_value_1',
                              presentation: 'option_value_1',
                              option_type: option_type)

        @params = {'option_type_1'=> option_value,
                   'option_type_2'=> '2020/02/05',
                   'option_type_3'=> '1',
                   'product_type'=> 'any'}
      end

      it 'should create all context option values in the database' do
        @context.set_persisted_option_values(@params)
      end
    end
  end

  describe "with rate" do
    describe 'when setting persisted attributes' do
      let(:rate) { create(:rate) }
      let(:default_zone) { Spree::Zone.new }

      before do
        option_types = [
            {name: 'option_type_1', presentation: "Option Type 1", attr_type: 'date', travel: true, preciable: false},
            {name: 'option_type_2', presentation: "Option Type 2", attr_type: 'date', travel: true, preciable: false},
            {name: 'option_type_3',   presentation: "Option Type 3", attr_type: 'integer', travel: true, preciable: true},
        ]

        option_types.each do |cot|
          option_type = create(:option_type_decorated, name: cot[:name],
                               presentation: cot[:presentation],
                               attr_type: cot[:attr_type],
                               travel: cot[:travel],
                               preciable: cot[:preciable])
          @product_type.rate_option_types << option_type
        end

        @params ={ 'option_type_1' => '2020/02/05',
                   'option_type_2' => '2020/03/07',
                   'option_type_3' => '60',
                   'product_type' => 'any' }

        allow(Spree::Zone).to receive(:default_tax).and_return(default_zone)
      end

      it 'should create all rate option values in the database' do
        rate.set_persisted_option_values(@params)

        assert_equal '2020/02/05', rate.get_persisted_option_value('option_type_1')
        assert_equal '2020/03/07', rate.get_persisted_option_value('option_type_2')
        assert_equal '$60.00', rate.get_persisted_option_value('option_type_3').format
      end
    end
  end
end