### These are the option types

### This is the data
option_values = [
]

### Creating Option Values
option_values.each do |ov|
  Spree::OptionValue.create!(ov)
end
