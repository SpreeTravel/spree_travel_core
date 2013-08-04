class Spree::Parser

#class Spree::Parser < ActiveSupport::TestCase
#  fixtures :properties
  
#  def self.load_properties
#	#property = Spree::OpenerpLoader.find_or_create(Spree::Property, :name => :properties(:one).name.to_url, :presentation => :properties(:one).name)	
#    properties(:one)
#  end 

  def self.parse(file_name)
    arr = IO.readlines(file_name)
    products = []
    arr_prod = []
    for l in 0..arr.length
      line = arr[l]
      if l == arr.length or line =~ /product:/
        products << self.parse_prod(arr_prod) unless arr_prod.blank?
        arr_prod = []
      else
        arr_prod << line
      end
    end
    products
  end

  def self.parse_prod(arr)
    p = Spree::Product.create
    any_node = /(name:|chain:|price:|taxons:|relations:|stars:|address:|check_in_time:|check_out_time:|location:|description:|property_type:|variants:|star:)/
    last_line =""; relations =""; star = ""; address = ""; check_in_time = ""; check_out_time = ""; location = ""; chain = "";
    property_type = ""; option_types = ""; variants = ""; taxons = "";
    arr_in = []
    for l in 0..arr.length
      line = arr[l]
      if l == arr.length or line =~ any_node and not ( (line =~ /name:/        and not p.name.blank?) or
                                                       (line =~ /description:/ and not p.description.blank?) )
        case last_line
          when /taxons:/            then self.parse_taxons(arr_in,p)
          when /location:/          then self.parse_location(arr_in,p)
          when /relations:/         then self.parse_relations(arr_in,p)
          when /property_type:/     then self.parse_property_type(arr_in,p)          
          when /variants:/          then self.parse_variants_implicit(arr_in,p)
          when /name:/              then p.name = self.format(arr_in);  p.permalink = p.name.to_url;
          when /stars:/             then p.stars = self.format(arr_in).to_i
          when /price:/             then p.price = self.format(arr_in).to_i
          when /description:/       then p.description = self.format(arr_in)
          when /address:/           then address = self.format(arr_in)
          when /check_in_time:/     then check_in_time = self.format(arr_in)
          when /check_out_time:/    then check_out_time = self.format(arr_in)
          when /chain:/             then chain = self.format(arr_in)
        end

        arr_in = []
        end_part_of_line = line.split(":")[1]        if line
        arr_in << end_part_of_line unless end_part_of_line.blank?
        last_line = line
      else
        arr_in << line
      end
    end

    dic = {:taxons => taxons,:relations => relations,:star => star, :address => address,
            :check_in_time => check_in_time,:check_out_time => check_out_time,:location => location,
            :chain => chain,:property_type => property_type,:variants => variants}
    p.price = 0.0
    p.save

  end

  def self.parse_taxons(arr,prod)
    puts "########################## Parse_taxons"
    puts arr

    last_line = ""
    arr_in = []
    taxons = []
    any_node = /name:/
    prod.taxons = [] unless prod.taxons

    for l in 0..arr.length
      line = arr[l]
      if l  ==  arr.length or line =~ any_node
        case last_line
          when /name:/
            name = self.format( arr_in )
            taxon = Spree::Taxon.where( :name => name )[0]
            prod.taxons << taxon unless taxon.blank?
            taxons << taxon
        end
        arr_in = []
        end_part_of_line = if line then line.split(":")[1] else "" end 
        arr_in << end_part_of_line unless end_part_of_line.blank?
        last_line = line
      else
        arr_in << line
      end
    end
    taxons
  end

  def self.parse_relations(arr,prod)
    puts "########################## Parse_relations"
    puts arr

    last_line = ""
    relations = []
    a_related_to = []
    a_relation_type = []
    arr_in = []
    any_node = /(relation_type:|related_to:)/

    for l in 0..arr.length
      line = arr[l]
      if l  ==  arr.length or line =~ any_node
        case last_line
          when /relation_type:/
            a_relation_type << self.format( arr_in ).to_url.tr("-","_")
            puts "///////////////////////a_relation_type ///#{a_relation_type}"

          when /related_to:/
            a_related_to << self.format( arr_in )
            puts "///////////////////////a_related_to ///#{a_related_to}"
        end
        arr_in = []
        end_part_of_line = ""
        puts "line #{line}"

        end_part_of_line = line.split(":")[1]  if line && line.split(":")[1]

        puts "end_part_of_line #{end_part_of_line}"

        arr_in = end_part_of_line unless end_part_of_line.blank?
        last_line = line

      else
        arr_in << line
      end
    end

    for k in 0..a_relation_type.length-1
      relation_type = a_relation_type[k]
      related_to = a_related_to[k]
      puts "prod #{prod.inspect} and name #{prod.name}"
      relations << self.relat(related_to, prod, relation_type)
    end
    relations
  end

  def self.relat(related_to, relatable, relation_type)

    puts "relatable  #{relatable.name}"
    relatable.price = 10
    puts relatable.save

    rel_to = Spree::Product.where(:name => related_to)[0]
    puts rel_to

    relation_type = Spree::RelationType.where( :name  =>  relation_type)[0]

    Spree::Relation.create( :relatable => relatable, :related_to => rel_to, :relation_type => relation_type)
  end


  def self.parse_location(arr,item)
    puts "########################## Parse_location"
    puts arr
  end

  def self.parse_property_type(arr,prod)
    puts "########################## Parse_property_type"
    puts arr
    property_type = Spree::PropertyType.create
    any_node = /(name:|properties:)/
    last_line = ""; properties =  "";
    arr_in = []
    for l in 0..arr.length
      line = arr[l]
      if l == arr.length || line =~ any_node && !(line =~ /name:/ ) || property_type.name.blank?
        case last_line
          when /properties:/  then  self.parse_properties(arr_in, property_type, prod)
          when /name:/        then  property_type.name = self.format(arr_in)
        end
        arr_in = []
        end_part_of_line = if line then line.split(":")[1] else "" end 
        arr_in << end_part_of_line unless end_part_of_line.blank?
        last_line = line
      else
        arr_in << line
      end
    end
    property_type.save
    property_type
  end


  def self.parse_properties(arr,property_type, prod)
    puts "########################## Parse_properties"
    puts arr

    last_line = ""
    arr_in = []; properties = [];
    any_node = /(name:|local_payment:|on_request:)/
    prod.properties = [] unless prod.properties

    for l in 0..arr.length
      line = arr[l]
      if l  ==  arr.length or line =~ any_node
        case last_line
          when /name:/
            name = self.format(arr_in)
            property = Spree::OpenerpLoader.find_or_create(Spree::Property, :name => name.to_url, :presentation => name)
            Spree::OpenerpLoader.find_or_create(Spree::ProductProperty, :property_id => property.id, :product_id => prod.id)
            prod.properties << property
            properties << property
          when /local_payment:/ then true
          when /on_request:/ then true
        end
        arr_in = []
        end_part_of_line = if line then line.split(":")[1] else "" end 
        arr_in << end_part_of_line unless end_part_of_line.blank?
        last_line = line
      else
        arr_in << line
      end
    end
    properties
  end

  def self.parse_option_types(arr,prod)
    puts "########################## Parse_option_types"
    puts arr
    last_line = ""
    arr_in = []
    option_values = []
    option_types = []

    prod.option_types = [] unless prod.option_types

    any_node = /(name:|option_values:)/

    for l in 0..arr.length
      line = arr[l]
      if l  ==  arr.length or line =~ any_node
        case last_line
          when /name:/
            name = self.format( arr_in )
            option_type = Spree::OpenerpLoader.find_or_create( Spree::OptionType, :name => name.to_url, :presentation => name )
            Spree::OpenerpLoader.find_or_create( Spree::ProductOptionType, :option_type_id => option_type.id , :product_id => prod.id)
            prod.option_types << option_type
            option_types << option_type
          when /option_values:/   then option_values << arr_in
        end
        arr_in = []
        end_part_of_line = if line then line.split(":")[1] else "" end 
        arr_in << end_part_of_line unless end_part_of_line.blank?
        last_line = line
      else
        arr_in << line
      end
    end


    for k in 0..option_types.length-1
      option_type = option_types[k]
      arr_in = option_values[k]

      self.parse_option_values(arr_in, option_type)
    end
    option_types
  end

  def self.parse_option_values(arr,option_type)
    puts "########################## Parse_option_values"
    puts arr
    last_line = ""
    arr_in = []
    option_values = []
    any_node = /value:/

    for l in 0..arr.length
      line = arr[l]
      if l  ==  arr.length or line =~ any_node
        case last_line
          when /value:/
            name = self.format(arr_in)
            option_value = Spree::OpenerpLoader.find_or_create(Spree::OptionValue, :name => name.to_url, :presentation => name, :option_type_id => option_type.id)
            option_values << option_value
        end
        arr_in = []
        end_part_of_line = if line then line.split(":")[1] else "" end 
        arr_in << end_part_of_line unless end_part_of_line.blank?
        last_line = line
      else
        arr_in << line
      end
    end
    option_values
  end

  def self.parse_variants(arr,prod)
    puts "########################## Parse_variants"
    puts arr

    a_option_types = arr[0].split(";")
    a_option_types.pop #remove price
    a_option_types.shift #remove from
    a_option_types.shift #remove to


    option_types_id = []
    variants = []

    for ot in  a_option_types
      puts "////////////////////// #{ot}"
      option_types_id << Spree::OptionType.where(:name => ot.to_url)[0].id
    end

    for l in 1..arr.length-1
	  line = arr[l] 	
      next if line.blank?      
      puts "line #{line}"
      values = line.split(";")
      price = values.pop.strip.to_i

      variant = Spree::Variant.create(:product_id => prod.id ,:price =>0 )
      variant.save
      variant.option_values = [] unless variant.option_values.blank?

      from = values.shift
      puts "from #{from}"
      to = values.shift
      puts "to #{to}"

      season = Spree::OptionType.where(:presentation => "Season")[0]
      variant.option_values << Spree::OptionValue.where(:presentation => "From #{from.strip} To #{to.strip}").where(:option_type_id=> season.id)[0]

      variant.price = price

      for v in 0..values.length-1
        name_value = values[v]
        value = Spree::OptionValue.where(:name => name_value.to_url).where(:option_type_id=> option_types_id[v])[0]
        variant.option_values << value
      end
      variant.save
      variants << variant
    end
    variants
  end


  def self.parse_variants_implicit(arr,prod)
    puts "########################## Parse_variants"
    puts arr
    prod = Spree::Product.create(:name => "temp", :price => 0)
    arr = IO.readlines("./db/implicit_variants")
    
    last_line = ""
    arr_in = []
    variants = []
    range_paxs = []
    exceptions = []
    seasons = []
    rates = []

    any_node = /(rate:|range_paxs:|exceptions:|seasons:)/

    for l in 0..arr.length
      line = arr[l]
      if l  ==  arr.length or line =~ any_node
        case last_line
          when /rate:/  			then  rates = arr_in	
          when /option_types:/      then  self.parse_option_types(arr_in,p)
          when /range_paxs:/      	then  range_paxs = arr_in
          when /exceptions:/      	then  exceptions = arr_in
          when /seasons:/         	then  seasons = arr_in
        end
        arr_in = []
        end_part_of_line = if line then line.split(":")[1] else "" end
        arr_in << end_part_of_line unless end_part_of_line.blank?
        last_line = line
      else
        arr_in << line
      end
    end

	name = "Season"
    option_type_season = Spree::OpenerpLoader.find_or_create( Spree::OptionType, :name => name.to_url, :presentation => name )	
    prod.option_types = [] unless prod.option_types
    prod.option_types << option_type_season
    
	for s in 1..season.length-2
	  if s%2 ==0  
		from = self.format(season[s].split(":")[1])
		to = self.format(season[s + 1].split(":")[1])				
		name = "From #{from} To #{to}"
        option_value = Spree::OpenerpLoader.find_or_create(Spree::OptionValue, :name => name.to_url, :presentation => name, :option_type_id => option_type_season.id)        						
	  end	
    end
    
    
    ranges = {}
    for l in  0..range_paxs.length-2
      if l%2 == 0
        name = self.format(range_paxs[l].split("name:")[1])
        option_type = Spree::OptionType.where(:presentation => name)[0]
        option_values = []
        temp = range_paxs[ l + 1 ].split("range:")[1].strip
        from = temp.split("..")[0]
        to = temp.split("..")[1]
        range = (from.to_i..to.to_i).to_a

        for elem in range
          option_value = Spree::OptionValue.where(:presentation => elem).where(:option_type_id => option_type.id)[0]
          option_values << option_value
        end
        ranges.update({ option_type => option_values})
      end
    end

    combinations = comb(ranges.values)
    
   

=begin
    exps = []
    for l in  0..exceptions.length-1
      values = range_paxs[l].split("value:")[1].to_s.split(",")[1]

      puts "////////////////////////////////////////option_value_presentation //#{option_value.presentation}"
      e = []
      for v in values
        option_type = Spree::OptionType.where( v.split("-")[0])
        option_value = Spree::OptionValue.where(:presentation => v.split("-")[1]).where(:option_type_id => option_type.id)
        e << option_value
      end
      exp << e
    end
=end


    for c in combinations
      variant = Spree::Variant.create(:product_id => prod.id ,:price =>rand(100) )
      variant.save
      variant.option_values = [] unless variant.option_values.blank?
      
      puts "/////////valores de las combinaciones//////////////////////// #{c.map{|v| v.presentation}}"
      
      for v in c
        variant.option_values << v
      end
      variant.save
      variants << variant
    end

    for s in rates
      dic = parse_rate(s)
      for v in variants
          v
      end
    end

    variants
  end


  def self.parse_rate(arr)
    puts "########################## parse_season"
    puts arr
    last_line = ""
    arr_in = []
    option_values = []
    any_node = /(adults_in_base:|price_base:|price_extra_adult:|price_child:|price_infant:|only_with_two_adults:|price_extra:)/

    from = ""
    to = ""
    price_base = 0
    adults_in_base = 0
    price_infant = 0
    price_extra_adult = 0
    price_child = 0
    only_with_two_adults = false

    for l in 0..arr.length
      line = arr[l]
      if l  ==  arr.length or line =~ any_node
        case last_line
          when /adults_in_base:/       then adults_in_base = self.format(arr_in).to_i
          when /price_base:/           then price_base = self.format(arr_in).to_i
          when /price_infant:/         then price_infant = self.format(arr_in).to_i
          when /price_extra_adult:/    then price_extra_adult = self.format(arr_in).to_i
          when /only_with_two_adults:/ then only_with_two_adults = self.format(arr_in)
        end
        arr_in = []
        end_part_of_line = if line then line.split(":")[1] else "" end
        arr_in << end_part_of_line unless end_part_of_line.blank?
        last_line = line
      else
        arr_in << line
      end
    end
    {   
        :price_base => price_base,
        :price_infant => price_infant,
        :price_extra_adult => price_extra_adult,
        :price_child => price_child,
        :only_with_two_adults => only_with_two_adults
    }

  end

  def self.parse_price_extra(arr)
    puts "########################## parse_season"
    puts arr

    last_line = ""
    arr_in = []
    any_node = /(option_type:|value:|price:)/

    option_types = []
    values = []
    prices = []
    result = {}

    for l in 0..arr.length
      line = arr[l]
      if l  ==  arr.length or line =~ any_node
        case last_line
          when /option_type:/     then option_types << self.format(arr_in)
          when /value:/           then values << self.format(arr_in)
          when /price:/           then prices << self.format(arr_in).to_i
        end
        arr_in = []
        end_part_of_line = if line then line.split(":")[1] else "" end
        arr_in << end_part_of_line unless end_part_of_line.blank?
        last_line = line
      else
        arr_in << line
      end
    end

    for v in 0..values.length-1
      option_type_id = Spree::OptionType.where(:presentation => option_types[v])[0].id
      option_value = Spree::OptionValue.where(:presentation => values[v]).where(:option_type_id => option_type_id)
      result << {option_value => prices[v]}

    end
    result
  end

  def self.format(arr_in)
    arr_in.to_s.split("\n").map{|s| s.strip.compact}.to_s unless arr_in.blank?
  end




  def self.combination
    dic = {}
    dic.update({ "Adult" => [1, 2, 3] })
    dic.update({ "Child" => [1, 2, 3] })
    dic.update({ "Infant" => [1, 2, 3]})

    dic = #[["1","2","3"],[:a,:b,:c],[:p,:q,:r]]
    dic =  [(1..3).to_a,(0..3).to_a, (0..3).to_a]      #
    dic =  #[[:a],[:p,:q,:r]]

    comb(dic)
  end

  def self.comb(a)

    result = []
    return a[0].map{|e| [e]} if a.length == 1

    first = a.shift
    combs = comb(a)

    for elem in first
      for r in combs
          result << [elem] + r
      end
    end
    result
  end



  def get_price (dic_rate,dic_pax)

    dic_rate = 	{ :adults_in_base => 2,
                  :base_price => 10,
                  :extra_adult_price => 12,
                  :child_price => 10,
                  :infant_price => 12,
                  :only_with_parents => true,                  							
                  
                  :price_extra => { 
						:option_types => {
							"Meal plan" => {	
								"Continental breakfast" => 15,
								"Modified American plan" => 10,
								"American plan" => 12
							}	
						},
						:property => {
							"Meal plan" => {	
								"Continental breakfast" => 15,
								"Modified American plan" => 10,
								"American plan" => 12
							}	
						}											  
                  }
                }

    dic_context = { :adult => 3,
					:child => 0,
					:infant => 0,
					:meal_plan => "Continental breakfast",
					:only_with_two_adults => true
				   }

    result = 0

	if dic_context[:adult] >= dic[adults_in_base]
		result += dic_rate[:price_base]
	end
    if dic_context[:adult] > dic[rate_in_base]
		result += (dic_context[:adult] - dic_rate[:adult_in_base]  ) * dic_rate[:price_extra_adult]		
    end
	if dic_context[:child] > 0
		result += dic_rate[:price_child] * dic_context[:child] 		
    end
	if dic_context[:infant] > 0
		result += dic_rate[:price_infant] * dic_context[:infant] 		
    end
	if dic_context[:meal_plan]		
		result += dic_rate[:price_extra][dic_context[:meal_plan]]
    end
	result
  end



end




