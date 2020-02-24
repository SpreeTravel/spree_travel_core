require 'spec_helper'

describe Spree::PersistedDynamicAttribute do

  describe 'when setting a persisted attributes for a context to populate the order' do
    before do
      @context = Spree::Context.new
      @context.initialize_variables
      @context.extend(Spree::PersistedDynamicAttribute)

      option_types = [
          {name: 'category', presentation: 'Category', attr_type: 'selection', travel: true, preciable: false},
          {name: 'pickup_date', presentation: 'Pickup Date', attr_type: 'date', travel: true, preciable: false},
          {name: 'return_date', presentation: 'Return Date', attr_type: 'date', travel: true, preciable: false},
          {name: 'pickup_destination', presentation: 'Pickup Destination', attr_type: 'destination', travel: true, preciable: false},
          {name: 'return_destination', presentation: 'Return Destination', attr_type: 'destination', travel: true, preciable: false},
          {name: 'adult', presentation: 'Adult', attr_type: 'integer', short: 'Adult', travel: true, preciable: false},
      ]
      car_product_type = create(:product_type, name: 'car', presentation: 'Car')

      option_types.each do |cot|
        option_type = create(:option_type_decorated, name: cot[:name],
                                                     presentation: cot[:presentation],
                                                     attr_type: cot[:attr_type],
                                                     travel: cot[:travel],
                                                     preciable: cot[:preciable])
        car_product_type.context_option_types << option_type
      end

      category = Spree::OptionType.find_by_name!('category')
      category = create(:option_value_decorated, name: 'economic', presentation: 'Economic', option_type: category)

      @params = {'category'=> category,
                 'pickup_destination'=> 'Cienfuegos',
                 'return_destination'=> 'La Habana',
                 'pickup_date'=> '2020-02-02',
                 'return_date'=> '2020-02-05',
                 'adult'=> '1',
                 'product_type'=> 'car'}
    end

    it 'should create all context option values in the database' do
      allow_any_instance_of(Spree::ContextOptionValue).to receive(:save).and_return(true)
      save_count = 0
      allow_any_instance_of(Spree::ContextOptionValue).to receive(:save) { |arg| save_count += 1 }
      @context.set_persisted_option_values(@params)
      expect(save_count).to eq 7
    end
  end

  describe 'when setting persisted attributes for a rate' do
    before do
      option_types = [
          {name: "start_date", presentation: "Start Date", attr_type: 'date', travel: true, preciable: false},
          {name: "end_date",   presentation: "End Date",   attr_type: 'date', travel: true, preciable: false},
          {name: 'three_six_days',   presentation: "3 to 6 days", attr_type: 'integer', travel: true, preciable: true},
          {name: 'seven_thirteen_days',  presentation: "7 to 13 days", attr_type: 'integer', travel: true, preciable: true},
          {name: 'fourteen_twentynine_days', presentation: "14 to 29 days", attr_type: 'integer', travel: true, preciable: true}
      ]

      car_product_type = create(:product_type, name: 'car', presentation: 'Car')

      option_types.each do |cot|
        option_type = create(:option_type_decorated, name: cot[:name],
                                                     presentation: cot[:presentation],
                                                     attr_type: cot[:attr_type],
                                                     travel: cot[:travel],
                                                     preciable: cot[:preciable])
        car_product_type.context_option_types << option_type
      end

      rates = %w(start_date end_date)
      car_product_type.rate_option_types << rates.each.map {|r| Spree::OptionType.find_by_name(r)}

      @rate = Spree::Rate.new(variant_id: 1)
      @params ={'start_date'=>'2020/02/05',
                'end_date'=>'2020/02/29',
                'product_type'=>'car' }
      @rate.set_persisted_option_values(@params)
     end
    
    it 'should create the rate for the specified variant' do
      expect(@rate.start_date).to eq '2020/02/05'
      expect(@rate.end_date).to eq '2020/02/29'
      expect { @rate.non_existing_context_attr }.to raise_error(NoMethodError)
    end
  end


end