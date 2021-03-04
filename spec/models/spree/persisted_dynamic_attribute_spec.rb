require 'spec_helper'

describe Spree::PersistedDynamicAttribute do

  before do
    @product_type = create(:product_type, name: 'any', presentation: 'Any')
  end

  describe 'with context' do
    describe 'when storing the context in the database' do

      before do
        option_types = [
            {name: 'option_type_1', presentation: 'Option Type 1', attr_type: 'selection', travel: true, preciable: false},
            {name: 'option_type_2', presentation: 'Option Type 2', attr_type: 'date', travel: true, preciable: false},
            {name: 'option_type_3', presentation: 'Option Type 3', attr_type: 'pax', travel: true, preciable: false},
        ]

        option_types.each do |cot|
          option_type = create(:option_type_decorated, name: cot[:name],
                               presentation: cot[:presentation],
                               attr_type: cot[:attr_type],
                               travel: cot[:travel],
                               preciable: cot[:preciable])
          @product_type.context_option_types << option_type
        end

        @option_type = Spree::OptionType.find_by(name: 'option_type_1')
        option_value = create(:option_value,
                              name: 'the_name',
                              presentation: 'The Presentation',
                              option_type: @option_type)

        @params = {'any_option_type_1'=> option_value.id,
                   'any_option_type_2'=> '2020/02/05',
                   'any_option_type_3'=> '1',
                   'product_type'=> 'any'}
      end

      it 'should create all context option values in the database' do
        context = Spree::Context.build_from_params(@params, temporal: false)

        assert_equal 'The Presentation', context.persisted_option_value('option_type_1')
        assert_equal '2020/02/05', context.persisted_option_value('option_type_2')
        assert_equal 1, context.persisted_option_value('option_type_3')

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
            {name: 'option_type_2',   presentation: "Option Type 3", attr_type: 'price', travel: true, preciable: true},
            {name: 'option_type_3',   presentation: "Option Type 4", attr_type: 'pax', travel: true, preciable: false},
        ]

        option_types.each do |cot|
          option_type = create(:option_type_decorated, name: cot[:name],
                               presentation: cot[:presentation],
                               attr_type: cot[:attr_type],
                               travel: cot[:travel],
                               preciable: cot[:preciable])
          @product_type.rate_option_types << option_type
        end

        @params ={ 'any_option_type_1' => '2020/02/05',
                   'any_option_type_2' => '60',
                   'any_option_type_3' => '1',
                   'product_type' => 'any' }

        allow(Spree::Zone).to receive(:default_tax).and_return(default_zone)
      end

      it 'should create all rate option values in the database' do
        rate.persist_option_values(@params)
        assert_equal '2020/02/05', rate.persisted_option_value('option_type_1')
        assert_equal '$60.00', rate.persisted_option_value('option_type_2').format
        assert_equal 1, rate.persisted_option_value('option_type_3')
      end
    end
  end
end