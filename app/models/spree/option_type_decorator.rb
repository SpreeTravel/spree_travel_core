module Spree
  OptionType.class_eval do

    after_create :default_option_value

    def default_option_value
      if attr_type != 'selection' && option_values.empty?
        OptionValue.create(
                           :name => self.name,
                           :presentation => self.presentation,
                           :option_type_id => self.id
                           )
      end
    end

  end
end
