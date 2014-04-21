module Spree
  Variant.class_eval do

    has_many :rates, :class_name => 'Spree::Rate', :foreign_key => 'variant_id'
    #belongs_to :product_type, :through => :product

    def options_text
      values = self.option_values.joins(:option_type).order("#{Spree::OptionType.table_name}.position asc")
      values.map! do |ov|
        "#{ov.option_type.presentation}: #{ov.presentation}</br>"
      end
      values.to_sentence({ words_connector: "", two_words_connector: "", last_word_connector: "" }).html_safe
    end

    def count_on_hand
      100
    end

  end
end
