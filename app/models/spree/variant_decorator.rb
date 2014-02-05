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

    def self.prepare_params(params)
      # TODO: cambiar el variant hotel por el que venga en params
      # TODO: optimizar este metoditoc, sobre todo si se mete dentro de un burujon de ciclos anidados lentos
      result = []
      options_to_search = Spree::VariantHotel.get_options_to_search
      params.each do |option, value|
        option_hash = options_to_search.find {|h| h[:option] == option}
        next unless option_hash
        operator = option_hash[:operator]
        option_type = OptionType.find_by_name(option)
        value =  option_type.name + '-' + value.to_s unless value.to_s.include?('-')
        sov = "sov_" + option_type.name
        sovv = "sovv_" + option_type.name
        result << {:option => option, :value => value, :sov => sov, :sovv => sovv,
          :option_type_id => option_type.id, :operator => operator}
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
        sovv = hash[:sovv]
        sov = hash[:sov]
        opt = hash[:option]
        val = hash[:value]
        otid = hash[:option_type_id]
        op = hash[:operator]
        sql1 += ", #{sov}.name AS #{opt}"
        sql3 += "INNER JOIN spree_option_values_variants AS #{sovv} ON #{sovv}.variant_id = sv.id "
        sql3 += "INNER JOIN spree_option_values AS #{sov} ON #{sov}.id = #{sovv}.option_value_id "
        sql5 += "AND #{sov}.option_type_id = #{otid} "
        sql5 += "AND #{sov}.name #{op} '#{val}' "
      end

      sql = sql0 + sql1 + sql2 + sql3 + sql4 + sql5
      puts '------------------------'
      puts sql
      puts '------------------------'
      list = Spree::Variant.find_by_sql(sql)
      where(:id => [list.map(&:id)])
   end

  end

end



#SELECT "spree_variants".* FROM "spree_variants" INNER JOIN "spree_option_values_variants" ON "spree_option_values_variants"."variant_id" = "spree_variants"."id" INNER JOIN "spree_option_values" ON "spree_option_values"."id" = "spree_option_values_variants"."option_value_id" WHERE "spree_variants"."deleted_at" IS NULL AND (spree_option_values.name = 'adult-2' AND spree_option_values.option_type_id = 7)

#SELECT "spree_variants".* FROM "spree_variants" INNER JOIN "spree_option_values_variants" ON "spree_option_values_variants"."variant_id" = "spree_variants"."id" INNER JOIN "spree_option_values" ON "spree_option_values"."id" = "spree_option_values_variants"."option_value_id" WHERE "spree_variants"."deleted_at" IS NULL AND (spree_option_values.name = 'adult-2' AND spree_option_values.option_type_id = 7) AND (spree_option_values.name = 'child-0' AND spree_option_values.option_type_id = 8)
