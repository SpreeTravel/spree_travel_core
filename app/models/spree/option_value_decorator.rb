Spree::OptionValue.class_eval do

  def position
    self.option_type.position
  end

  def self.find_or_create(name, presentation, option_type)
    ot = Spree::OptionType.find_by_name(option_type)
    option_value = self.where(:name => name).first_or_create(
        :presentation => presentation,
        :option_type_id => ot.id,
        :position => ot.position
    )
    option_value
  end

end
