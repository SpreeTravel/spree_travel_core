### This is the data
option_types = [
  {name: "start_date", presentation: "Start Date", attr_type: 'date', travel: true},
  {name: "end_date", presentation: "End Date", attr_type: 'date', travel: true},
  {name: "adult", presentation: "Adult", attr_type: 'pax', travel: true},
  {name: "child", presentation: "Child", attr_type: 'pax', travel: true},
  {name: "destination", presentation: "Destination", attr_type: 'destination', travel: true},
]

### Creating Option Types
option_types.each do |option_type|
  Spree::OptionType.where(name: option_type[:name]).first_or_create(presentation: option_type[:presentation],
                                                                    attr_type: option_type[:attr_type],
                                                                    travel: option_type[:travel])
end

### Creating Destination Taxonomy
Spree::Taxonomy.first_or_create( :name => "Destination")

