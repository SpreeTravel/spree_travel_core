  module Spree
  module Search
    class Solr

      def get_products_conditions_for(base_scope, query)
        if not @properties[:sort].nil? and Constant::SORT_FIELDS.has_key? @properties[:sort]
          sort_option = Constant::SORT_FIELDS[@properties[:sort]]
          base_scope = base_scope.order("#{sort_option[0]} #{sort_option[1].upcase}")
        end

        filter_queries  = ["is_active:(true)"]

        if !all_categories.blank?
          complete_filter = []
          all_categories.each do |cat|
            list = get_filter_queries([], cat[:all_taxons], cat[:variants], cat[:to_filter], cat[:to_filter_taxon], for_taxons)
            complete_filter << list.map{|f| "( #{f} )"}.join(" AND ")
          end
          filter_queries << complete_filter.map{|pf| "( #{pf} )"}.join(" OR ")
        else
          filter_queries = get_filter_queries(filter_queries, all_taxons, variants, to_filter, to_filter_taxon, for_taxons)
        end

        if !properties_include.blank?
          filter_queries << properties_include.map{|pi| "properties_include:(#{pi})"}.join(" AND ")
        end

        if properties_feature
          properties_feature.keys.each do |pf|
            filter_queries << properties_feature[pf].map{|f| "properties_feature:(#{f})"}.join(" OR ")
          end
        end

        facets = {
            :fields => Constant::SOLR_FACETS,
            :browse => @properties[:facets].map{|k,v| "#{k}:#{v}"},
            :zeros => false
        }

        search_options = {
            :relevance => {:name => 5, :description => 1},
            :facets => facets,
            :limit => @properties[:limit] || 25000,
            :lazy => true,
            :filter_queries => filter_queries
        }

        result = Spree::Product.find_by_solr(query || '', search_options)
        products = result.records

        @properties[:total_products] = result.total_entries
        @properties[:products] = products
        @properties[:suggest] = nil
        begin
          if suggest = result.suggest
            suggest.sub!(/\sAND.*/, '')
            @properties[:suggest] = suggest if suggest != query
          end
        rescue
        end

        @properties[:available_facets] = parse_facets_hash(result.facets)
        product_ids = products.map(&:id)
        if product_ids.count > 0
          base_scope = base_scope.where(["spree_products.id IN (?)", product_ids]).order( "field(id,#{product_ids.join(',')})" )
        else
          base_scope = base_scope.where(["spree_products.id IN (?)", product_ids])
        end
        base_scope
      end

      def get_filter_queries(filter_queries, all_taxons, variants, to_filter, to_filter_taxon, for_taxons=2)
        if !all_taxons.blank?
          if for_taxons == 1
            all_taxons.each do |tx|
              list = tx.self_and_descendants.flatten
              filter_queries << list.map{|t| "taxon_ids:(#{t.id})"}.join(" OR ")
            end
          elsif for_taxons == 2
            list = all_taxons.map(&:self_and_descendants).flatten
            filter_queries << list.map{|t| "taxon_ids:(#{t.id})"}.join(" OR ")
          elsif for_taxons == 3
            all_taxons.values.each do |ltxs|
              list = ltxs.map(&:self_and_descendants).flatten
              filter_queries << list.map{|t| "taxon_ids:(#{t.id})"}.join(" OR ")
            end
          end
        end

        if to_filter
          to_filter.keys.each do |k|
            filter_queries << "#{k}:(#{to_filter[k]})"
          end
        end

        if to_filter_taxon
          to_filter_taxon.each do |k, v|
            list = v.self_and_descendants
            filter_queries << list.map{|x| "#{k}:(#{x.id})"}.join(" OR ")
          end
        end

        if variants
          filter_queries << variants.map{|v| "variant_names:(#{v})"}.join(" OR ")
        end
        filter_queries
      end

      def prepare(params)
        super
        @properties[:suggest] = nil
        @properties[:facets] = params[:facets] || {}
        @properties[:available_facets] = []
        @properties[:manage_pagination] = false
        @properties[:per_page] = params[:items_per_page] || 10
        @properties[:sort] = params[:sort] || 'updated_desc'
        @properties[:total_products] = 0

        @properties[:all_taxons] = []
        @properties[:all_taxons] << Spree::Taxon.find(params[:taxon]) unless params[:taxon].blank?
        @properties[:for_taxons] = 1
        @properties[:taxons_for_home] = false
        @properties[:to_filter] = {}
        @properties[:to_filter][:name] = params[:name] if params[:name].present?
        @properties[:all_season] = []
        @properties[:all_categories] = []
        @properties[:limit] = params[:limit] if params[:limit]

        category = params[:id] ? params[:id] : nil
        if params[:keywords]
            @properties[:all_taxons] = [Spree::Taxon.find_by_permalink('categories'), Spree::Taxon.find_by_permalink('things-to-do')]
            @properties[:for_taxons] = 2
        elsif category.nil?
            @properties[:all_categories] = [
                get_properties_programs({:all_taxons => [Spree::Taxon.find_by_permalink('categories/programs')], :to_filter => {}}, params),
                get_properties_tours({:all_taxons => [Spree::Taxon.find_by_permalink('categories/tours')], :to_filter => {}}, params),
                get_properties_accommodation({:all_taxons => [Spree::Taxon.find_by_permalink('categories/accommodation')], :to_filter => {}}, params),
                get_properties_flights({:all_taxons => [Spree::Taxon.find_by_permalink('categories/flights')], :to_filter => {}}, params),
                get_properties_transfers({:all_taxons => [Spree::Taxon.find_by_permalink('categories/cars-and-transfers/transfers')], :to_filter => {}}, params),
                get_properties_cars({:all_taxons => [Spree::Taxon.find_by_permalink('categories/cars-and-transfers/rent-cars')], :to_filter => {}}, params),
            ]
        elsif category.start_with?('categories/programs')
            @properties = get_properties_programs(@properties, params)
        elsif category.start_with?('categories/tours')
            @properties = get_properties_tours(@properties, params)
        elsif category.start_with?('categories/accommodation')
            @properties = get_properties_accommodation(@properties, params)
        elsif category.start_with?('categories/flights')
            @properties = get_properties_flights(@properties, params)
        elsif category.start_with?('categories/cars-and-transfers/transfers')
            @properties = get_properties_transfers(@properties, params)
        elsif category.start_with?('categories/cars-and-transfers/rent-cars')
            @properties = get_properties_cars(@properties, params)
        else
          if !params[:recomended].nil?
            @properties[:all_categories] = [
                get_properties_programs({:all_taxons => [Spree::Taxon.find_by_permalink('categories/programs')], :to_filter => {}}, params),
                get_properties_tours({:all_taxons => [Spree::Taxon.find_by_permalink('categories/tours')], :to_filter => {}}, params),
                get_properties_accommodation({:all_taxons => [Spree::Taxon.find_by_permalink('categories/accommodation')], :to_filter => {}}, params)
            ]
          end
        end

        @properties[:properties_feature] = {}
        @properties[:properties_include] = []
        params.keys.each do |p|
          if p.start_with?('feature')
            for_key = p.split('-')
            for_key.pop
            key = for_key.join('-')
            for_value = p.split('-')
            for_value.delete_at(0)
            value = for_value.join('-')
            if @properties[:properties_feature][key].nil?
              @properties[:properties_feature][key] = [value]
            else
              @properties[:properties_feature][key] << value
            end
          elsif p.start_with?('include')
            list = p.split('-')
            list.delete_at(0)
            @properties[:properties_include] << list.join('-')
          elsif p.start_with?('categories') || p.start_with?('things-to-do')
            @properties = set_taxons_for_search_home(@properties, 'categories', p)
          elsif p.start_with?('destinations')
            @properties = set_taxons_for_search_home(@properties, 'destinations', p)
          end
        end

      end

      def set_taxons_for_search_home(properties, type, p)
        if properties[:taxons_for_home] == false
          properties[:all_taxons] = {}
          properties[:taxons_for_home] = true
        end
        if properties[:all_taxons][type].nil?
          properties[:all_taxons][type] = [Spree::Taxon.find_by_permalink(p)]
        else
          properties[:all_taxons][type] << Spree::Taxon.find_by_permalink(p)
        end
        properties[:for_taxons] = 3
        properties
      end

      def get_properties_programs(properties, params)
        properties[:all_taxons] << Spree::Taxon.find(params[:destination_program].to_i) unless params[:destination_program].blank?
        properties[:to_filter][:recomended] = params[:recomended] if params[:recomended]
        properties[:variants] = []
        date_program = (params[:date_program] || Constant.DEFAULT_DATE_PROGRAM).to_date
        seasons = get_seasons_candidates(date_program)
        vals = params[:adults_program].nil? ? [1,2,3,4,5,6,7,8] : [params[:adults_program]]
        vals.each do |adults|
          variant = "adult-#{adults}"
          variant += "|child-#{params[:children_program]}" if params[:children_program] && params[:children_program].to_i != 0
          variant += "|infant-#{params[:infants_program]}" if params[:infants_program] && params[:infants_program].to_i != 0
          properties[:variants] += seasons.map {|s| s.name + "|" + variant}
        end
        properties
      end

      def get_properties_tours(properties, params)
        properties[:all_taxons] << Spree::Taxon.find(params[:destination_program].to_i) unless params[:destination_program].blank?
        properties[:to_filter][:recomended] = params[:recomended] if params[:recomended]
        variant = "adult-1|child-0"
        date_program = (params[:date_program] || Constant.DEFAULT_DATE_PROGRAM).to_date
        seasons = get_seasons_candidates(date_program)
        properties[:variants] = seasons.map {|s| s.name + "|" + variant}
        properties
      end

      def get_properties_accommodation(properties, params)
        properties[:all_taxons] << Spree::Taxon.find(params[:destination_accommodation].to_i) unless params[:destination_accommodation].blank?
        properties[:to_filter][:recomended] = params[:recomended] if params[:recomended]
        properties[:variants] = []
        variant = ""
        variant += "|adult-#{params[:adults_accommodation] || Constant::DEFAULT_ADULTS_ACCOMMODATION.to_s}"
        variant += "|child-#{params[:children_accommodation]}" if params[:children_accommodation] && params[:children_accommodation].to_i != 0
        variant += "|infant-#{params[:infants_accommodation]}" if params[:infants_accommodation] && params[:infants_accommodation].to_i != 0
        check_in_accommodation = (params[:check_in_accommodation] || Constant.DEFAULT_CHECK_IN_ACCOMMODATION).to_date
        check_out_accommodation = (params[:check_out_accommodation] || Constant.DEFAULT_CHECK_OUT_ACCOMMODATION).to_date
        seasons = get_seasons_candidates(check_in_accommodation, check_out_accommodation)
        if !params[:meal_plan_accommodation].nil?
          meal_plan_ids = [params[:meal_plan_accommodation]]
        else
          meal_plan_ids = Spree::OptionValue.where(:option_type_id => Spree::OptionType.find_by_name('meal-plan').id).map(&:id)
        end
        meal_plan_ids.each do |mp|
          head_variant = Spree::OptionValue.find(mp).name
          complete_variant = head_variant + variant
          properties[:variants] += seasons.map {|s| s.name + "|" + complete_variant}
        end
        properties
      end

      def get_properties_flights(properties, params)
        properties[:all_taxons] << Spree::Taxon.find(params[:origin_flight].to_i) unless params[:origin_flight].blank?
        properties[:all_taxons] << Spree::Taxon.find(params[:destination_flight].to_i) unless params[:destination_flight].blank?
        properties[:to_filter][:recomended] = params[:recomended] if params[:recomended]
        variant = "trip-round-trip|adult-1|child-0"
        date_flight = (params[:date_flight] || Constant.DEFAULT_INIT_DATE_FLIGHT).to_date
        date_return_flight = (params[:date_return_flight] || Constant.DEFAULT_END_DATE_FLIGHT).to_date
        seasons = get_seasons_candidates(date_flight, date_return_flight)
        properties[:variants] = seasons.map {|s| s.name + "|" + variant}
        properties
      end

      def get_properties_transfers(properties, params)
        properties[:to_filter_taxon] = {}
        properties[:to_filter_taxon][:origin_taxon] = Spree::Taxon.find(params[:origin_transfer]) unless params[:origin_transfer].blank?
        properties[:to_filter_taxon][:destination_taxon] = Spree::Taxon.find(params[:destination_transfer]) unless params[:destination_transfer].blank?
        properties[:to_filter][:recomended] = params[:recomended] if params[:recomended]
        properties[:for_taxons] = 1
        a = params[:adults_transfer] ? params[:adults_transfer].to_i : Constant::DEFAULT_ADULTS_TRANSFER
        b = params[:children_transfer] ? params[:children_transfer].to_i : Constant::DEFAULT_CHILDREN_TRANSFER
        #variant =  params[:transfer_go_and_back] || Constant::DEFAULT_TRIP_TYPE_TRANSFER
        variant = get_str_range("pax", a + b) if a + b > 0
        if a + b <= 2
          confort = params[:confort_transfer] || Constant.DEFAULT_CONFORT_TRANSFER
        else
          confort = params[:confort_transfer]
        end
        variant += "|" + Spree::OptionValue.find(confort).name if confort
        date_transfer = (params[:date_transfer] || Constant.DEFAULT_INIT_DATE_TRANSFER).to_date
        date_return_transfer = (params[:date_return_transfer] || Constant.DEFAULT_END_DATE_TRANSFER).to_date        
        seasons = get_seasons_candidates(date_transfer, date_return_transfer)
        properties[:variants] = seasons.map {|s| s.name + "|" + variant}
        properties
      end

      def get_properties_cars(properties, params)
        properties[:to_filter][:recomended] = params[:recomended] if params[:recomended]
        properties[:variants] = []
        date_rent = (params[:date_rent] || Constant.DEFAULT_INIT_DATE_RENT).to_date
        date_devolution_rent = (params[:date_devolution_rent] || Constant.DEFAULT_END_DATE_RENT).to_date
        seasons = get_seasons_candidates(date_rent, date_devolution_rent)
        duration = get_str_range("duration", date_devolution_rent - date_rent)
        variant = duration if duration
        if !params[:transmission_rent].nil?
          transmission_ids = [params[:transmission_rent]]
        else
          transmission_ids = Spree::OptionValue.where(:option_type_id => Spree::OptionType.find_by_name('transmission').id).map(&:id)
        end
        transmission_ids.each do |tm|
          complete_variant = variant + "|" + Spree::OptionValue.find(tm).name
          properties[:variants] += seasons.map {|s| s.name + "|" + complete_variant}
        end
        properties
      end

      def get_str_range(option_type, n)
        option_type_obj = Spree::OptionType.find_by_name(option_type)
        option_type_obj.option_values.each do |ov|
          p = ov.name.split('-')[1]
          init_range, end_range = p.split('..')
          range = Range.new(init_range.to_i, end_range.to_i)
          return ov.name if range.include?(n)
        end
        return false
      end

      def get_seasons_candidates(in_date, out_date=nil)
        din = in_date.strftime('%Y/%m/%d')
        dout = out_date.strftime('%Y/%m/%d') if out_date
        sql = "SELECT sov.name AS name "
        sql += "FROM spree_option_values as sov "
        sql += "INNER JOIN spree_option_types AS sot ON sov.option_type_id = sot.id "
        sql += "WHERE sot.name = 'season' "
        if out_date.nil?
          sql += "AND date(substring_index(substring_index(sov.name, '-', 2), '-', -1)) <= date('#{din}') AND date(substring_index(sov.name, '-', -1)) >= date('#{din}') "
        else
          sql += "AND date(substring_index(substring_index(sov.name, '-', 2), '-', -1)) <= date('#{din}') AND date(substring_index(sov.name, '-', -1)) >= date('#{dout}') "
        end
        seasons = Spree::OptionValue.find_by_sql(sql)
        seasons
      end

    end
  end
end

