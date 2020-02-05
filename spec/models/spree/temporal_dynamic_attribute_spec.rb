require 'spec_helper'

describe Spree::TemporalDynamicAttribute do

  before do
    @context = Spree::Context.new
    @context.initialize_variables
    @context.extend(Spree::TemporalDynamicAttribute)

    option_types = [
        {name: 'category', presentation: 'Category', attr_type: 'selection'},
        {name: 'pickup_date', presentation: 'Pickup Date', attr_type: 'date'},
        {name: 'return_date', presentation: 'Return Date', attr_type: 'date'},
        {name: 'pickup_destination', presentation: 'Pickup Destination', attr_type: 'destination'},
        {name: 'return_destination', presentation: 'Return Destination', attr_type: 'destination'},
        {name: 'adult', presentation: 'Adult', attr_type: 'integer', short: 'Adult'},
    ]

    car_product_type = create(:product_type, name: 'car', presentation: 'Car')

    option_types.each do |cot|
      option_type = create(:option_type_decorated, name: cot[:name], presentation: cot[:presentation], attr_type: cot[:attr_type])
      car_product_type.context_option_types << option_type
    end
  end

  describe 'when setting temporal attributes for a context to calculate the price' do
    before do
      @params = {'category'=> '11',
                 'pickup_destination'=> 'Cienfuegos',
                 'return_destination'=> 'La Habana',
                 'pickup_date'=> '2020-02-02',
                 'return_date'=> '2020-02-05',
                 'adult'=> '1',
                 'product_type'=> 'car'}
      @context.set_temporal_option_values(@params)
    end

    it 'should returns all attributes setted as temporal' do
      expect(@context.category).to eq '11'
      expect(@context.pickup_destination).to eq 'Cienfuegos'
      expect(@context.return_destination).to eq 'La Habana'
      expect(@context.pickup_date).to eq '2020-02-02'
      expect(@context.return_date).to eq '2020-02-05'
      expect(@context.adult).to eq '1'
      expect(@context.product_type).to eq 'car'
      expect(@context.get_temporal.count).to eq 7
      expect { @context.non_existing_context_attr }.to raise_error(NoMethodError)
    end
  end
end