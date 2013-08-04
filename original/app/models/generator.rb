require "csv.rb"
class Generator
	def self.hotels_yml(file)				
		arr_of_arrs = CSV.read("/home/raul/RubymineProjects/grandSlam/code_pqr/spree_travel/app/models/#{file}")
		#arr_of_arrs = CSV.read("/media/Data/sancho/development/ceiba-grandslam/spree_travel/app/models/plantillas_de_hoteles_sol_melia.csv")

		#remove empty line
		arr_of_arrs.shift
		arr_of_arrs.shift
		arr_of_arrs.shift

		head = arr_of_arrs.shift
		
		destination = ""
			
		for j in 0..((arr_of_arrs.length) -1)		
			arr = arr_of_arrs[j]
			output = File.open("hotels_temp.yml", "a+")
			
			puts "/// //////////////////////////////Destino head[0]-------------------  #{arr[0].titleize}" if arr[0]
			if head[0] == "Destino" and not arr[0].blank? 	
				destination = arr[0].titleize
			end						
				
			if head[1] == "Nombre Hotel" and not arr[1].blank? 	and arr[2].blank?		    								
				puts p = "hotel-#{arr[1].to_url}:"				
				output.puts p
																
				properties = ""
				for i in 0..arr.length
					next if arr[i].blank? and not head[i] == "Destino"																	
					
					case head[i]						
					when "Nombre Hotel"
						puts p = " "*2 + "name: \"#{arr[i].titleize}\" "
						output.puts p						
						puts p = " "*2 + "description: \"#{arr_of_arrs[j + 1][i].to_s.gsub("\"","\'")}\" "					
						output.puts p
					when "Destino"	
						puts p = " "*2 + "destination: \"#{destination}\" "
						output.puts p										
					when "Categoría hotel"
						puts p = " "*2 + "stars: \"#{arr[i]}\" "					
						output.puts p
					when "Descripción"
						puts p = " "*2 + "description: \"#{arr[i]}\" "					
						output.puts p	
					when "Proveedor"
						puts p = " "*2 + "supplier: \"#{arr[i]}\""	
						output.puts p
					when "Prestatario"
						puts p = " "*2 + "partner: \"#{arr[i]}\""							
						output.puts p
					when "Modalidad"	
						modality = if arr[i] =~ /Playa/
										"beaches"
								   elsif  arr[i] =~ /Rural/
								   		"rurals"
								   elsif  arr[i] =~ /Ciudad/
										"cities"
								   else 	
										"beaches"
								   end
						puts p = " "*2 + "modality: \"#{modality}\""
						output.puts p
						
					when "Dirección"
						puts p = " "*2 + "location:"	
						output.puts  p
						puts p = " "*4 + "address: \"#{arr[i]}\""	
						output.puts  p
					when "Municipio"	
						puts p = " "*4 + "municipality: \"#{arr[i]}\""	
						output.puts  p
					when "Email"	
						puts p = " "*4 + "email: \"#{arr[i]}\""		
						output.puts  p
					when "Fax"	
						puts p = " "*4 + "fax: \"#{arr[i]}\""	
						output.puts  p
					when "Phone"	
						puts p = " "*4 + "phone: \"#{arr[i]}\""						
						output.puts  p
					when "Latitud"
						lat = ""
					    arr[i].split(',')[1..-1].each{|e| lat << e}
					    lat = "#{arr[i].split(',')[0]}.#{lat}"
						puts p = " "*4 + "latitud: #{lat}" 
						output.puts p
					when "Longitud"
						lon = ""
					    arr[i].split(',')[1..-1].each{|e| lon << e}
					    lon = "#{arr[i].split(',')[0]}.#{lon}"
						puts p = " "*4 + "longitud: #{lon}" 
						output.puts p	
					end
					
					if head[i] =~ /Hotel Amenity/  
						if properties.blank?
							properties = "#{arr[i]}" 
						else
							properties = properties + ",#{arr[i]}" 
						end	
					end	
													
				end
				
				
				puts p = " "*2 + "properties: \"#{properties}\" "
				output.puts	p
				
				puts p= " "*2 + "rooms:"
				output.puts  p
								
			elsif head[2] == "Nombre Habitación" and not arr[2].blank?			
				
				puts p = " "*4 + "room-#{arr[2].to_url}:"						
				output.puts	p
				
				puts p = " "*6 + "name: \"#{arr[2].titleize}\" "						
				output.puts	p	
				
				for i in 4..arr.length
					#next if arr[i].blank?					
					case head[i]						
					when "Plan alimenticio"	
						puts p = " "*6 + "plan-included: \"#{arr[i]}\""	
						output.puts  p												
					when "Confort"	
						puts p = " "*6 + "confort: \"#{arr[i]}\""	
						output.puts  p																								
					
					when "Nivel de servicio"
						puts p = " "*6 + "level_of_service: \"#{arr[i]}\""	
						output.puts  p

					when "Vista"
						next if arr[i].blank?
						puts p = " "*6 + "view: \"#{arr[i]}\""	
						output.puts  p
																				
					when "Temporada"			
					    k = 1				
					    puts p = " "*6 + "seasons:"
					    output.puts  p
					    
						while j+k < arr_of_arrs.length &&  i < arr_of_arrs[j+k].length && ! arr_of_arrs[j+k][i].blank?							
						    for l in i..arr_of_arrs[j+k].length						    
						        current = arr_of_arrs[j+k][l]						        						        						      
								next if current.blank?
																								
					            case head[l]	        
					            when "Temporada"
									puts p = " "*8 + "#{current.to_url}:"
									output.puts  p
					            when "F. Inicio"									
									puts p = " "*10 + "name: from-#{current}-to-#{arr_of_arrs[j+k][l+1]}"			
									output.puts  p
								when "Simple"
									puts p = " "*10 + "rate:" 
									output.puts  p
									puts p = " "*12 + "adults_in_base: 2"
									output.puts  p
									puts p = " "*12 + "single: #{current}"			
								    output.puts  p
								when "Doble"
									puts p = " "*12 + "doble: #{current}"								
									output.puts  p
								when "Triple"
									puts p = " "*12 + "triple: #{current}"								
									output.puts  p
								when "CP"
									puts p = " "*12 + "meal-plan:"
									output.puts  p								
									puts p = " "*14 + "continental-breakfast: #{current}"			
									output.puts  p
								when "MAP"
									puts p = " "*14 + "modified-american-plan: #{current}"			
									output.puts  p
								when "MAP (CHD)"
									puts p = " "*14 + "modified-american-plan-child: #{current}"			
									output.puts  p
								when "AP"
									puts p = " "*14 + "modified-american-plan: #{current}"			
									output.puts  p
								when "Adulto (+13) adicional"
									puts p = " "*12 + "extra-adults: #{current}"			
									output.puts  p
								when "Niño(3-12)"
									puts p = " "*12 + "child: #{current}"			
									output.puts  p
								when "2-Adultos?(SI/NO)"
									puts p = " "*12 + "only_with_parents: true"			
									output.puts  p								
								when "Bebé(0-2)"
									puts p = " "*12 + "infant: #{current}"			
									output.puts  p
								when "Max-Adultos"
									puts p = " "*12 + "max-adult: #{current}"			
									output.puts  p
								when "Max-Niños"				
									puts p = " "*12 + "max-child: #{current}"			
									output.puts  p																																
					            end
																
							end #for	
						
							k = k +1
						end	
					end	
				end																				
			end
		    output.close	
		    
		    #output = File.open("hotels_temp.yml", "a+")		    
		    #f_output = File.open("hotels.yml", "r")						   		  			
			#output.close

		end
		
	end
	

	def self.replace_special_chars										
		output = File.open("hotels.yml", "a+")	
		file = File.new("hotels_temp.yml", "r")			
		while (line = file.gets)
			line.gsub! /Á/ , 'á'
			line.gsub! /à/ , 'a'
			line.gsub! /É/ , 'é'								
			line.gsub! /Í/ , 'í'
			line.gsub! /Ó/ , 'ó'
			line.gsub! /Ú/ , 'ú'
			output.puts line 	
		end
		file.close								
		output.close					
	end

	
	def self.hotels_product_yml				
		file_path = File.join(File.dirname(__FILE__))
		
		#hotels = File.open( "#{file_path}/hotels.yml" ) { |yf| YAML::load( yf ) }				
		hotels = File.open( "hotels.yml" ) { |yf| YAML::load( yf ) }
				
		hotels.keys.each do |h|
			output = File.open("hotels_product.yml", "a+")	
			puts p = "#{h}:"
			output.puts p 			
			
			puts p = " "*2 + "name: \"#{hotels[h]["name"]}\" "
			output.puts p			
			

			puts p = " "*2 + "taxons: pl-#{hotels[h]["destination"].to_s.to_url}, mc-accommodation-#{hotels[h]["modality"].to_s.to_url}"
			output.puts p			
			
			puts p = " "*2 + "description: \"#{hotels[h]["description"]}\" "
			output.puts p
			
			puts p = " "*2 + "available_on: <%= Time.zone.now.to_s(:db) %>"
			output.puts p
			
			puts p = " "*2 + "count_on_hand: 0"
			output.puts p			
			
			puts p = " "*2 + "permalink: #{h}"
			output.puts p
			
			puts p = " "*2 + "longitud: #{hotels[h]["location"]["longitud"]} "
			output.puts p
			
			puts p = " "*2 + "latitud: #{hotels[h]["location"]["latitud"]} "
			output.puts p			
			
			hotels[h]["rooms"].keys.each do |r|
			    puts p = "#{r}-#{h}:"
			    output.puts p
				puts p = " "*2 + "name: \"#{hotels[h]["rooms"][r]["name"]}\" "			
				output.puts p
				puts p = " "*2 + "available_on: <%= Time.zone.now.to_s(:db) %>"
				output.puts p
				puts p = " "*2 + "permalink: #{r}-#{h}"				
				output.puts p			
			end			
			output.close
			
		end		
	end
	
	
	
	

	def self.generate_properties				
		arr = IO.readlines("/media/Data/sancho/development/ceiba-grandslam/spree_travel/app/models/properties")       
		
		#output = File.open("output", "w")

		arr.each do |line|
			puts
		    puts "prop-#{line.to_url}:"
		    puts " "*2 + "presentation: #{line}"
		    puts " "*2 + "name: #{line.to_url}"
		    puts " "*2 + "property_type: pro-type-hotel-amenity"		    		    		    		 				
		end
		puts "////////////////////////"

		arr.each do |line|
			puts
		    puts "melia-cohiba-a-#{line.to_url}:"
		    puts " "*2 + "product: melia-cohiba"
		    puts " "*2 + "property: prop-#{line.to_url}"
		    puts " "*2 + "value: #{line}"		    
		end
	end
	
	def self.assets_taxon				
		  #img-taxon-cuba.jpg:  
		  #id: 36
		  #viewable: pl-cuba
		  #viewable_type: Spree::Taxon
		  #attachment_content_type: image/jpg
		  #attachment_file_name: taxons/destinations/cuba.jpg
		  #attachment_width: 360
		  #attachment_height: 360
		  #type: Spree::Image  
		  #position: 1
		  
		arr = IO.readlines("/media/Data/sancho/development/ceiba-grandslam/spree_travel/app/models/taxons")       
		
		#output = File.open("output", "w")

		arr.each do |line|
			puts
		    puts "img-taxon-#{line.to_url}:"
		    puts " "*2 + "viewable: pl-#{line}"
		    puts " "*2 + "viewable_type: Spree::Taxon"
		    puts " "*2 + "attachment_content_type: image/jpg"
		    puts " "*2 + "attachment_file_name: taxons/destinations/#{line.strip}.jpg"	
		    puts " "*2 + "attachment_width: 360"
		    puts " "*2 + "attachment_height: 360"		    
		    puts " "*2 + "type: Spree::Image"
		    puts " "*2 + "position: 1"		    		    		    		 				
		end

	
	end

	def self.assets_programs				
	
		#img-hotel-melia-cohiba-1:
		#viewable: hotel-melia-cohiba
		#viewable_type: Spree::Product
		#attachment_content_type: image/jpg
		#attachment_file_name: categories/accommodation/cities/hotel-melia-cohiba/hotel-1.jpg
		#attachment_width: 360
		#attachment_height: 360 	
		#type: Spree::Image  
		#position: 1
		  
		arr = IO.readlines("/media/Data/sancho/development/ceiba-grandslam/spree_travel/app/models/programs")       
		
		#output = File.open("output", "w")
	
		arr.each do |line|
			1.upto(3) do |i| 
				puts
				puts "img-#{line.to_url}-#{i}:"
				puts " "*2 + "viewable: program-#{line}"
				puts " "*2 + "viewable_type: Spree::Product"
				puts " "*2 + "attachment_content_type: image/jpg"
				puts " "*2 + "attachment_file_name: categories/programs/#{line.strip}/#{line.strip}-#{i}.jpg"	
				puts " "*2 + "attachment_width: 360"
				puts " "*2 + "attachment_height: 360"		    
				puts " "*2 + "type: Spree::Image"
				puts " "*2 + "position: #{i}"		    		    		    		 				
			end
		end
	
	end

	
	def self.assets_tours				
	
		#img-hotel-melia-cohiba-1:
		#viewable: hotel-melia-cohiba
		#viewable_type: Spree::Product
		#attachment_content_type: image/jpg
		#attachment_file_name: categories/accommodation/cities/hotel-melia-cohiba/hotel-1.jpg
		#attachment_width: 360
		#attachment_height: 360 	
		#type: Spree::Image  
		#position: 1
		  
		arr = IO.readlines("/media/Data/sancho/development/ceiba-grandslam/spree_travel/app/models/tours")       
		
		#output = File.open("output", "w")
	
		arr.each do |line|
			1.upto(3) do |i| 
				puts
				puts "img-#{line.to_url}-#{i}:"
				puts " "*2 + "viewable: tour-#{line}"
				puts " "*2 + "viewable_type: Spree::Product"
				puts " "*2 + "attachment_content_type: image/jpg"
				puts " "*2 + "attachment_file_name: categories/programs/#{line.strip}/#{line.strip}-#{i}.jpg"	
				puts " "*2 + "attachment_width: 360"
				puts " "*2 + "attachment_height: 360"		    
				puts " "*2 + "type: Spree::Image"
				puts " "*2 + "position: #{i}"		    		    		    		 				
			end
		end
	
	end

	def self.hotel_variant_yml				
		file_path = File.join(File.dirname(__FILE__))
		
		hotels = File.open( "#{file_path}/hotels.yml" ) { |yf| YAML::load( yf ) }				
				
		hotels.keys.each do |h|
			output = File.open("hotels_product.yml", "a+")	
			puts p = "#{h}:"
			output.puts p 			
			puts p = " "*2 + "name: \"#{hotels[h]["name"]}\" "
			output.puts p			
			puts p = " "*2 + "description: \"#{hotels[h]["description"]}\" "
			output.puts p
			puts p = " "*2 + "available_on: <%= Time.zone.now.to_s(:db) %>"
			output.puts p
			puts p = " "*2 + "permalink: #{h}"
			output.puts p
			puts p = " "*2 + "longitud: #{hotels[h]["location"]["longitud"]}"
			output.puts p
			puts p = " "*2 + "latitud: #{hotels[h]["location"]["latitud"]}"
			output.puts p			
			hotels[h]["rooms"].keys.each do |r|
			    puts p = "#{r}-#{h}:"
			    output.puts p
				puts p = " "*2 + "name: \"#{hotels[h]["rooms"][r]["name"]}\" "			
				output.puts p
				puts p = " "*2 + "available_on: <%= Time.zone.now.to_s(:db) %>"
				output.puts p
				puts p = " "*2 + "permalink: #{r}-#{h}:"				
				output.puts p			
			end			
			output.close
			
		end
								
	end


	def self.variant_hotel				   				
		file_path = File.join(File.dirname(__FILE__))
		#hotels = File.open( "#{file_path}/hotels.yml" ) { |yf| YAML::load( yf ) }						
		hotels = File.open( "hotels.yml" ) { |yf| YAML::load( yf ) }			
					
		hotels.keys.each do |hotel| 
			output = File.open("hotels_variant.yml", "a+")
			name_hotel = hotels[hotel]["name"].to_url						
			#puts "hotels[hotel] #{hotels[hotel]}"
			
			puts p = "#{name_hotel}-v-master-variant:"
			output.puts p
			puts p = " "*2 + "product: hotel-#{name_hotel}"
			output.puts p			    
			puts p = " "*2 + "sku: #{name_hotel.hash.abs}" 
			output.puts p
			puts p = " "*2 + "price: 0"
			output.puts p
			puts p = " "*2 + "master_variant: true"				
			output.puts p

			
			hotels[hotel]["rooms"].keys.each do |r| 	
				
				puts "hotels[hotel][r] #{hotels[hotel][r]}"
				
				puts "hotels[hotel][\"rooms\"] #{hotels[hotel]["rooms"]}"
				 				
			    dic_room = hotels[hotel]["rooms"][r]
			    room = dic_room["name"].to_url			   
			    
			    puts p = "room-#{room}-hotel-#{name_hotel}-v-master-variant:"
			    output.puts p
				puts p = " "*2 + "product: room-#{room}-hotel-#{name_hotel}"
				output.puts p			    
				puts p = " "*2 + "sku: #{room.hash.abs}" 
				output.puts p
				puts p = " "*2 + "price: 0"
				output.puts p
				puts p = " "*2 + "master_variant: true"				
				output.puts p
																					  
				dic_room["seasons"].keys.each do |s| 					
					dic_room["seasons"][s]["rate"]["meal-plan"].keys.each do |m|					
						1.upto(3) do |i| 
							1.upto(3) do |j| 
								1.upto(3) do |k|  
									dic_context = {"adult" => i,"child" => j, "infant" => k,"meal-plan" => m}
									 
									puts p = "room-#{room}-holel-#{name_hotel}-v-#{s}-adult_#{i}-child_#{j}-infant_#{k}-#{m}:"
									output.puts p
									puts p = " "*2 + "product: room-#{room}-hotel-#{name_hotel}"
									output.puts p
									puts p = " "*2 + "option_values: #{dic_room["seasons"][s]["name"]},adult-#{i},child-#{j},infant-#{k},#{m}"
									output.puts p
									puts p = " "*2 + "sku: #{s.hash.abs + i + j + k + m.hash.abs}" 
									output.puts p
									#puts " "*2 + "price: #{a = rand(100)} #self.get_price(hotels[hotel][:dic_rate],dic_context)}"
									puts p = " "*2 + "price: #{a = self.get_price(dic_room["seasons"][s]["rate"],dic_context)}"
									output.puts p
									# puts p = " "*2 + "cost_price: = #{a-1}" 
									# output.puts p																		
								end    
							end  
						end
					end
					
				end				
			end
			output.close
		end	
	end
	
	
	def self.hotel_property_yml				   				
		hotels = File.open( "hotels.yml" ) { |yf| YAML::load( yf ) }						
		properties = []			
		hotels.keys.each do |h|		 			
			next_properties = hotels[h]["properties"].to_s.split(",")
			
			next_properties.each do |prop|
				properties << prop
			end			
		end
		
		properties.uniq!.sort!
		
		output = File.open("hotels_property.yml", "a+")
				
		properties.each do |prop|							
			puts p = "prop-#{prop.to_s.to_url}:"		
			output.puts p
			puts p = " "*2 + "presentation: #{prop}"
			output.puts p
		    puts p = " "*2 + "name: #{prop.to_s.to_url}"
		    output.puts p
		    puts p = " "*2 + "property_type: pro-type-hotel-amenity"
		    output.puts p		   
		end
		
				
		properties_room = {"Nivel de servicio" => ["Superior", "Lujo"], 
						   "Confort" => ["Standard", "Junior Suite", "Suite"], 
						   "Vista" => ["Vista al Mar"]
						   }
		
		properties_room.keys.each do |prop|										
			puts p = "prop-#{prop.to_s.to_url  }:"		
			output.puts p
			puts p = " "*2 + "presentation: #{prop}"
			output.puts p
			puts p = " "*2 + "name: #{prop.to_s.to_url}"
			output.puts p			
			puts p = " "*2 + "property_type: pro-type-room-amenity"
			output.puts p	
					   
		end
		
		output.close		
				
				
		output = File.open("hotels_product_property.yml", "a+")
		hotels.keys.each do |h|		 	
			hotels[h]["properties"].split(',').each do |prop|
				puts p = "#{h}-has-a-#{prop.to_url}:"		
				output.puts p
				puts p = " "*2 + "product: #{h}"
				output.puts p
				puts p = " "*2 + "property: prop-#{prop.to_url}"				
				output.puts p
				puts p = " "*2 + "value: \"#{prop}\" "				
				output.puts p
			end 
		end
		
		hotels.keys.each do |h|		 			
			hotels[h]["rooms"].keys.each do |r|
				
				confort = hotels[h]["rooms"][r]["confort"]
			    plan_included = hotels[h]["rooms"][r]["plan-included"]
			    level_of_service = hotels[h]["rooms"][r]["level_of_service"]
			    view = hotels[h]["rooms"][r]["view"]
			    
			    unless confort.blank?
					puts p = "#{r}-#{confort.to_url}:"		
					output.puts p
					puts p = " "*2 + "product: #{r}"
					output.puts p
					puts p = " "*2 + "property: prop-confort"				
					output.puts p
					puts p = " "*2 + "value: \"#{confort}\" "				
					output.puts p
				end					
				
				unless plan_included.blank?
					puts p = "#{r}-#{plan_included.to_url}:"		
					output.puts p
					puts p = " "*2 + "product: #{r}-#{h}"
					output.puts p
					puts p = " "*2 + "property: prop-plan-included"				
					output.puts p
					puts p = " "*2 + "value: \"#{plan_included}\" "				
					output.puts p					
				end
				
				unless level_of_service.blank?
					puts p = "#{r}-#{level_of_service.to_url}:"		
					output.puts p
					puts p = " "*2 + "product: #{r}-#{h}"
					output.puts p
					puts p = " "*2 + "property: prop-level_of_service"				
					output.puts p
					puts p = " "*2 + "value: \"#{level_of_service}\" "				
					output.puts p					
				end	
				
				unless view.blank?
					puts p = "#{r}-#{view.to_url}:"		
					output.puts p
					puts p = " "*2 + "product: #{r}-#{h}"
					output.puts p
					puts p = " "*2 + "property: prop-view"				
					output.puts p
					puts p = " "*2 + "value: \"#{view}\" "				
					output.puts p					
				end	
			end			
		end
		
		
		output.close		
							
	end
	
	def self.dic_hotels
		hotels = File.open( "hotels.yml" ) { |yf| YAML::load( yf ) }																
		output = File.open("dic_hotels.yml", "a+")
		
		puts p = "DIC_HOTELS = {"
		output.puts p				
		hotels.keys.each do |h|		 					
			puts p = " \"#{h} \" => ["
			output.puts p
			hotels[h]["rooms"].keys.each do |r|
				puts p = " "*2 + " \"#{r.split("room-")[1]}-#{h}\", "			
				output.puts p				
			end
			puts p = " "*2 + "],"
			output.puts p
		end
		puts p = "}"
		output.puts p		
		output.close
		
		
	
	end
	
	
	def self.get_price(dic_rate = {}, dic_context = {})
		result = 0
		if dic_context.blank?
			dic_context = {
            "adult" => 2, 
            "child" => 2, 
            "infant" => 100, 
            "meal-plan" => 'modified-american-plan' ,             
          }
		end
		
	    if dic_rate.blank?
          dic_rate = {
            "adults_in_base" => 2, 
            "single" => 144, 
            "doble" => 100, 
            "triple" => 95, 
            "meal-plan" => {
              "continental-breakfast" => "Incluido",
              "modified-american-plan" => 25,
              "modified-american-plan-child" => 12.5
            },  
            "extra-adult" => "15%",
            "child" => "100%",
            "only_with_parents" => true,
            "child" => "100%",
            "infant" => "100%",
            "max-adult" => 3,
            "max-child" => 2 
          }
        end  
            
		if dic_context["adult"] >= 2
			result += dic_rate["doble"]
		end
		if dic_context["adult"] > dic_rate["adults_in_base"]
			#puts "dic_rate[\"extra_adults\"]  -------------#{dic_rate["extra_adults"]}"
			if dic_rate["extra_adults"] and not dic_rate["extra_adults"].blank?
				result += (dic_context[:adult] - dic_rate["adults_in_base"]  ) * dic_rate["extra_adults"].to_i/100		
			else
				result += 0
			end	
		end
		if dic_context["child"] > 0			
		    #puts "dic_rate[\"child\"]  -------------#{dic_rate["child"]}"
			if dic_rate["child"] and not dic_rate["child"].blank?		
				result += dic_rate["child"].to_i/100 * dic_context["child"]
			else
				result += 0
			end
		end
		if dic_context["infant"] > 0
			result += dic_rate["infant"].to_i/100 * dic_context["infant"] 		
		end
		if dic_context["meal_plan"]		
			result += dic_rate["meal-plan"][dic_context["meal_plan"]]
		end
		result = rand(100) unless result.blank? 
		result		
	end
	
	def self.all_hotels
		self.hotels_yml("plantillas_de_hoteles_sol_melia.csv")
		self.hotels_yml("plantillas_de_hoteles_habaguanex.csv")
		self.hotels_yml("plantillas_de_hoteles_iberostart.csv")		
		self.replace_special_chars
		self.hotels_product_yml
		self.variant_hotel	   		
		self.hotel_property_yml
		self.dic_hotels
	end
end
