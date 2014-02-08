module Spree
  Variant.class_eval do

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
      self.get_option_value_from_type('start_date')
    end

    def end_date
      self.get_option_value_from_type('end_date')
    end

    def get_option_value_from_name(option)
      self.option_values.map(&:name).select{|ov| ov.starts_with?(option)}.first
    end

    def get_option_value_from_type(type)
      self.option_values.select{|ov| ov.option_type.name == type}.first.name
    end

    def self.prepare_params(params)
      # TODO: cambiar el variant hotel por el que venga en params
      # TODO: optimizar este metodito
      result = []
      options_to_search = Spree::VariantHotel.get_options_to_search
      params.each do |option, value|
        option_hash = options_to_search.find {|h| h[:option] == option}
        next unless option_hash
        option_type = OptionType.find_by_name(option)
        # TODO: la pregunta correcta es unless value sea una fecha
        value = OptionValue.find(value.to_i).name unless value.to_s.include?('-')
        result << {
          :option => option,
          :value => value,
          :sov => "sov_" + option_type.name,
          :sovv => "sovv_" + option_type.name,
          :option_type_id => option_type.id,
          :operator => option_hash[:operator]
        }
      end
      result
    end

    def self.with_option_values(params)
      filtered_params = prepare_params(params)
      sql0 = "SELECT sv.id AS id, sv.product_id AS product_id"
      sql1 = ""
      sql2 = " FROM spree_variants AS sv "
      sql3 = ""
      sql4 = "WHERE 1 > 0 "
      sql5 = ""

      for hash in filtered_params
        sql1 += ", #{hash[:sov]}.name AS #{hash[:option]}"
        sql3 += "INNER JOIN spree_option_values_variants AS #{hash[:sovv]} ON #{hash[:sovv]}.variant_id = sv.id "
        sql3 += "INNER JOIN spree_option_values AS #{hash[:sov]} ON #{hash[:sov]}.id = #{hash[:sovv]}.option_value_id "
        sql5 += "AND #{hash[:sov]}.option_type_id = #{hash[:option_type_id]} "
        sql5 += "AND #{hash[:sov]}.name #{hash[:operator]} '#{hash[:value]}' "
      end
      debugger
      sql = sql0 + sql1 + sql2 + sql3 + sql4 + sql5
      where(:id => [Spree::Variant.find_by_sql(sql).map(&:id)])
    end

  end

end
