Spree::OptionValue.class_eval do

  def position
    self.option_type.position
  end

  def find_or_create(name, presentation, option_type)
    option_value = OptionValue.where(:name => name).first_or_create(
        :presentation => presentation,
        :option_type_id => Spree::OptionType.find_by_name(option_type).id
    )
    option_value
  end

end
