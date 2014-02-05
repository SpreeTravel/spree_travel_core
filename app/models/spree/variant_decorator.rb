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
      self.get_option_value_from_type('start-season')
    end

    def end_date
      self.get_option_value_from_type('end-season')
    end

    def get_option_value_from_name(option)
      self.option_values.map(&:name).select{|ov| ov.starts_with?(option)}.first
    end

    def get_option_value_from_type(type)
      self.option_values.select{|ov| ov.option_type.name == type}.first.name
    end

    def self.filter_params(params)
      # TODO: implementar este metodo
      new_params = params
      result = []
      new_params.each do |option, value|
        option_type = OptionType.find_by_name(option)
        value =  option_type.name + '-' + value.to_s unless value.to_s.include?('-')
        generado = "sov_" + option_type.name
        generado2 = "sovv_" + option_type.name
        result << {:option => option, :value => value, :generado => generado, :generado2 => generado2}
      end
      result
    end

    def self.with_option_values(params)
      filtered_params = filter_params(params)
      sql    = "SELECT sv.id AS id, sv.product_id AS product_id"
      for hash in filtered_params
        sql += ", #{hash[:generado]}.name AS #{hash[:option]} "
      end
      sql   += "FROM spree_variants AS sv "
      for hash in filtered_params
        g2 = hash[:generado2]
        g1 = hash[:generado]
        sql += "INNER JOIN spree_option_values_variants AS #{g2} ON #{g2}.variant_id = sv.id "
        sql += "INNER JOIN spree_option_values AS #{g1} ON #{g1}.id = #{g2}.option_value_id "
      end
      sql   += "WHERE 1 > 0 "
      for hash in filtered_params
        sql += "AND #{hash[:generado]}.name = '#{hash[:value]}'"
      end
      puts sql
      list = Spree::Variant.find_by_sql(sql)
      where(:id => [list.map(&:id)])
   end
  end

end



#SELECT "spree_variants".* FROM "spree_variants" INNER JOIN "spree_option_values_variants" ON "spree_option_values_variants"."variant_id" = "spree_variants"."id" INNER JOIN "spree_option_values" ON "spree_option_values"."id" = "spree_option_values_variants"."option_value_id" WHERE "spree_variants"."deleted_at" IS NULL AND (spree_option_values.name = 'adult-2' AND spree_option_values.option_type_id = 7)

#SELECT "spree_variants".* FROM "spree_variants" INNER JOIN "spree_option_values_variants" ON "spree_option_values_variants"."variant_id" = "spree_variants"."id" INNER JOIN "spree_option_values" ON "spree_option_values"."id" = "spree_option_values_variants"."option_value_id" WHERE "spree_variants"."deleted_at" IS NULL AND (spree_option_values.name = 'adult-2' AND spree_option_values.option_type_id = 7) AND (spree_option_values.name = 'child-0' AND spree_option_values.option_type_id = 8)
