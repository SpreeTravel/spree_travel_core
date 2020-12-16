require 'spec_helper'

describe Spree::TemporalDynamicAttribute do

  before do
    @context = Spree::Context.new

    option_types = [
        {name: 'option_type_1', presentation: 'Category', attr_type: 'selection'},
        {name: 'option_type_2', presentation: 'Pickup Date', attr_type: 'date'},
        {name: 'option_type_3', presentation: 'Pickup Destination', attr_type: 'destination'},
        {name: 'option_type_4', presentation: 'Adult', attr_type: 'integer', short: 'Adult'},
    ]

    @product_type = create(:product_type, name: 'any', presentation: 'Any')

    option_types.each do |cot|
      option_type = create(:option_type_decorated,
                           name: cot[:name],
                           presentation: cot[:presentation],
                           attr_type: cot[:attr_type])
      @product_type.context_option_types << option_type
    end
  end

  describe 'when setting temporal attributes for a context to calculate the price' do
    before do
      @params = {'option_type_1'=> '11',
                 'option_type_2'=> 'Cienfuegos',
                 'option_type_3'=> '2020-02-02',
                 'option_type_4'=> '1',
                 'product_type'=> 'any'}
      @context.initialize_variables
    end

    it 'should validate the option_types' do
      expect(Spree::ProductType).to receive(:find_by_name).and_return(@product_type)
      expect_any_instance_of(Spree::ProductType).to receive(:send).with('context_option_types').and_return(@product_type.context_option_types)
      @context.set_temporal_option_values(@params)
    end
  end
end