Spree::Variant.class_eval do

  def options_text
    values = self.option_values.joins(:option_type).order("#{Spree::OptionType.table_name}.position asc")
    values.map! do |ov|
      "#{ov.option_type.presentation}: #{ov.presentation}</br>"
    end
    values.to_sentence({ words_connector: "", two_words_connector: "", last_word_connector: "" }).html_safe
  end
  
  def long_sku
    self.option_values.order(:position).map(&:name).join('-')
  end

  def adults
    self.get_option_value_from_name('adult').to_i
  end

  def children
    self.get_option_value_from_name('child').to_i
  end

  def start_date
    self.get_option_value_from_type('start_season').to_d
  end

  def end_date
    self.get_option_value_from_type('end_season').to_d
  end

  def get_option_value_from_name(option)
    self.option_values.map(&:name).select{|ov| ov.starts_with?(option)}.first
  end

  def get_option_value_from_type(type)
    self.option_values.select{|ov| ov.option_type.name == type}.first.name
  end

end
