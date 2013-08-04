class Spree::EmulateSeed
	
  def self.generate_all
	self.generate_taxonomies
	self.generate_properties
	self.generate_option_types
	self.generate_relation
	#Spree::Parser.parse("app/models/spree/formato.txt")
	
  end	
  
  def self.delete_all
	Spree::OpenerpLoader.delete_all
  end

  def self.generate_taxonomies

#Taxonomies
    Spree::Taxonomy.create([{ :name => Constant::DESTINATIONS },
                            { :name => Constant::SITE },
                            { :name => Constant::ALL_PRODUCTS },
                            { :name => Constant::FLIGHT_DESTINATIONS }
                           ])
#Taxon.roots
    for taxonomy in Spree::Taxonomy.all
      Spree::Taxon.create( { :name => taxonomy.name, :taxonomy => taxonomy })
    end

    self.generate_taxons_destination
    self.generate_taxons_fligth_destination
    self.generate_taxons_products
    self.generate_taxons_site

  end



  def self.generate_taxons_destination
    #..............................................
    #Destination Taxons
    taxonomy = Spree::Taxonomy.find_by_name(Constant::DESTINATIONS)
    elems = [ [ "Cuba",             taxonomy.name],
              [ "Pinar del Río",    "Cuba" ],
              [ "María la Gorda",   "Pinar del Río"],
              [ "Cayo Levisa" ,     "Pinar del Río"],
              [ "Viñales" ,         "Pinar del Río"],
              [ "Soroa" ,           "Cuba"],
              [ "Las Terrazas" ,    "Cuba"],
              [ "La Habana" ,       "Cuba"],
              [ "Jibacoa" ,         "Cuba"],
              [ "Matanzas" ,        "Cuba"],
              [ "Varadero" ,        "Matanzas"],
              [ "Villa Clara" ,     "Cuba"],
              [ "Cayo Ensenachos" , "Villa Clara"],
              [ "Cayo Santa María", "Villa Clara"],
              [ "Sancti Spíritus" , "Cuba"],
              [ "Topes de Collante","Sancti Spíritus"],
              [ "Trinidad" ,        "Sancti Spíritus"],
              [ "Jardines del Rey", "Cuba"],
              [ "Cayo Coco" ,       "Jardines del Rey"],
              [ "Cayo Guillermo" ,  "Jardines del Rey"],
              [ "Camagüey" ,        "Cuba"],
              [ "Holguín" ,         "Cuba"],
              [ "Guardalavaca" ,    "Holguín"],
              [ "Santiago de Cuba" ,"Cuba"],
              [ "Baracoa" ,         "Cuba"]
    ]
    self.create_taxon_of(taxonomy, elems)
  end



  def self.generate_taxons_fligth_destination
#..............................................
#Fligth Destination Taxons
    taxonomy = Spree::Taxonomy.find_by_name(Constant::FLIGHT_DESTINATIONS)
    elems = [ [ "Cuba",      taxonomy.name],
              [ "Varadero",    "Cuba" ],
              [ "La Habana",   "Cuba" ],
              [ "Francia",    taxonomy.name],
              [ "Paris",    "Francia"],
              [ "España",    taxonomy.name],
              [ "Madrid",    "España"]

    ]

    self.create_taxon_of(taxonomy, elems)
  end

  def self.generate_taxons_products
#..............................................
#Product Taxons
    taxonomy = Spree::Taxonomy.find_by_name(Constant::ALL_PRODUCTS)
    elems = [ [ "Program", taxonomy.name],
              [ "City",     "Program"],
              [ "Culture",  "Program"],
              [ "Nautical", "Program"],
              [ "Rural" ,   "Program"],

              [ "Tours" , taxonomy.name],
              [ "Air Tours" , "Tours"],
              [ "Day Tours",  "Tours"],
              [ "Nigth Tours","Tours"],
              [ "Overnight",  "Tours"],
              [ "Nautical",   "Tours"],

              [ "Flights" , taxonomy.name],
              [ "Domestic" ,    "Flights"],
              [ "International","Flights"],

              [ "Acomodation" , taxonomy.name],
              [ "Citys",        "Acomodation"],
              [ "Beach",       "Acomodation"],
              [ "Rurals",       "Acomodation"],
              [ "In The Cays", "Acomodation"],

              [ "Cars & Transfers" , taxonomy.name],
              [ "Transfers" , "Cars & Transfers"],
              [ "Rent a Car" ,"Cars & Transfers"]
    ]

    self.create_taxon_of(taxonomy, elems)
  end

  def self.generate_taxons_site
#...........................................................
#Site Taxons
    taxonomy = Spree::Taxonomy.find_by_name(Constant::SITE)
    elems =  [[ "Hotels",             taxonomy.name],
              [ "Eat out",            taxonomy.name],
              [ "Drinks",             taxonomy.name],
              [ "Nigthlife",          taxonomy.name],
              [ "Shopping",           taxonomy.name],
              [ "Cigars",             taxonomy.name],
              [ "Beaches",            taxonomy.name],
              [ "Interesting places", taxonomy.name]
    ]

    self.create_taxon_of(taxonomy, elems)
  end



  def self.create_taxon_of(taxonomy, elems)
    taxon = taxonomy.root
    for elem in elems
      parent = Spree::Taxon.find_by_name(elem[1])
      taxon = Spree::Taxon.create( {:name => elem[0], :parent_id => parent.id, :taxonomy_id => taxonomy.id })
    end
  end

  def self.generate_properties
    dic = {}
    dic.update({ "Hotel Amenity" => "24-hour front desk
                                            24-hour room service
                                            24-hour security
                                            Adjoining rooms
                                            Air conditioning
                                            Airline desk
                                            ATM/Cash machine
                                            Baby sitting
                                            BBQ/Picnic area
                                            Bilingual staff
                                            Bookstore
                                            Boutiques/stores
                                            Brailed elevators
                                            Business library
                                            Car rental desk
                                            Casino
                                            Check cashing policy
                                            Check-in kiosk
                                            Cocktail lounge
                                            Coffee shop
                                            Coin operated laundry
                                            Concierge desk
                                            Concierge floor
                                            Conference facilities
                                            Courtyard
                                            Currency exchange
                                            Desk with electrical outlet
                                            Doctor on call
                                            Door man
                                            Driving range
                                            Drugstore/pharmacy
                                            Duty free shop
                                            Elevators
                                            Executive floor
                                            Exercise gym"})

    dic.update( { "Room Amenity" => "Adjoining rooms
                                            Air conditioning
                                            Alarm clock
                                            All news channel
                                            AM/FM radio
                                            Baby listening device
                                            Balcony/Lanai/Terrace
                                            Barbeque grills
                                            Bath tub with spray jets
                                            Bathrobe
                                            Bathroom amenities
                                            Bathroom telephone
                                            Bathtub
                                            Bathtub only
                                            Bathtub/shower combination
                                            Bidet
                                            Bottled water
                                            Cable television
                                            Coffee/Tea maker
                                            Color television
                                            Computer
                                            Connecting rooms
                                            Converters/ Voltage adaptors
                                            Copier
                                            Cordless phone
                                            Cribs
                                            Data port
                                            Desk
                                            Desk with lamp
                                            Dining guide
                                            Direct dial phone number
                                            Dishwasher
                                            Double beds
                                            Dual voltage outlet
                                            Electrical current voltage
                                            Ergonomic chair
                                            Extended phone cord
                                            Fax machine
                                            Fire alarm
                                            Fire alarm with light
                                            Fireplace
                                            Free toll free calls
                                            Free calls
                                            Free credit card access calls
                                            Free local calls
                                            Free movies/video
                                            Full kitchen
                                            Grab bars in bathroom
                                            Grecian tub
                                            Hairdryer
                                            High speed internet connection
                                            Interactive web TV
                                            International direct dialing
                                            Internet access"})

    dic.update({ "Size" => "Taxi
                            Microbus
                            Minibus
                            Omnibus"})

    dic.update({ "Vehicle Category" => "Economic
                                        Medio
                                        Standard
                                        Higth Standard
                                        Minivan"})

    dic.update({ "Vehicle Insurance" => "Additional liability insurance
                                          Accident liability waiver
                                          Accident protection insurance
                                          Baggage coverage
                                          Complete cover package
                                          Collision damage insurance
                                          Collision damage waiver
                                          Collision damage waiver plus
                                          Collision damage waiver reduced liability
                                          Compulsory insurance
                                          Collision damage waiver LDW combo
                                          Collision damage waiver LDW combo plus
                                          Damage excess reduction
                                          Damage waiver
                                          Damage waiver plus
                                          Full coverage
                                          Glass tire waiver
                                          Insurance deductible waiver
                                          Insurance deductible waiver plus
                                          Insurance deductible waiver reduced liability
                                          Insurance
                                          Liability deductible coverage
                                          Loss damage insurance
                                          Loss damage waiver
                                          LDW deductible waiver
                                          Loss damage waiver reduced liability
                                          Liability insurance supplement
                                          Mexican insurance
                                          Non-waiverable responsibility
                                          Partial coverage
                                          Partial damage waiver
                                          Personal accident insurance
                                          Personal accident coverage
                                          Personal accident and effects coverage
                                          Personal effects protection
                                          Personal effects coverage
                                          Personal passenger protection
                                          Personal property insurance
                                          Rental liability protection
                                          Super collision damage waiver
                                          Special coverage
                                          Supplemental liability insurance
                                          Super personal accidental and effects coverage
                                          Super personal accident insurance
                                          Super theft protection
                                          Theft protection waiver
                                          Theft insurance
                                          Theft protection
                                          Third party coverage
                                          Third party insurance
                                          Third party plus
                                          Uninsured motorist coverage
                                          Unlimited mileage waiver
                                          Waiver
                                          Young drivers insurance
                                          Max cover
                                          AER (Accident Excess Reduction) plus
                                          AER (Accident Excess Reduction)
                                          Super cover
                                          Zero deductible option
                                          Protection package" })

    dic.update({ "Feature" => "Baggages 3
                              Baggages 4
                              Baggages 3
                              Air conditioning
                              Persons 4
                              Persons 5
                              Persons 6
                              Automatic Transmition" })

    dic.update({ "Star" => "2
                           3
                           4
                           5" })

    for key in dic.keys
      dic[key] = dic[key].split("\n").map{|e| e.strip}
      property_type = Spree::PropertyType.create({:name => key.to_url, :show => key})
      for elem in dic[key]
        Spree::Property.create({ :name => elem.to_url, :presentation => elem, :property_type_id => property_type.id})
      end
    end

  end


  def self.generate_option_types
    paxs = %W[Adult Tenegger Child Infant]
    for i in (0..paxs.length)
      option_type = Spree::OptionType.create({:name => paxs[i], :presentation => paxs[i], :position => i+1})
      for j in (1..5)
        Spree::OptionValue.create({ :name => j.to_s, :presentation => j.to_s, :position => j, :option_type_id => option_type.id})
      end
    end
    dic = {}
    dic.update({ "Meal Plan" => "All inclusive
                                American plan
                                Bed & breakfast
                                Buffet breakfast
                                Caribbean breakfast
                                Continental breakfast
                                English breakfast
                                European plan
                                Family plan
                                Full board
                                Full breakfast
                                Modified American plan
                                As brochured
                                Room only" })

    i = 1
    for key in dic.keys
      dic[key] = dic[key].split("\n").map{|e| e.strip}
      option_type = Spree::OptionType.create({:name => key.to_url, :presentation => key, :position => i })
      i += 1
      j = 1
      for elem in dic[key]
        Spree::OptionValue.create({ :name => elem.to_url, :presentation => elem, :property_type_id => option_type.id, :position => j})
        j += 1
      end
    end

  end


  
  def self.generate_relation
    relations = %W[ is_part_of_hotel
                     is_part_of_rent_a_car
                     is_part_of_package
                     is_part_of_transfer
                     is_part_of_destination
                     is_point_of_interest
                     is_part_of_route
                     is_main_part_of_hotel
                     is_main_part_of_rent_a_car
                     is_main_part_of_package
                     is_main_part_of_transfer
                     is_main_part_of_destination
                     is_main_part_of_route ]
    relations.each{ |r| Spree::RelationType.create(:name => r, :applies_to => 'Spree::Product') }
  end
  
  

  def self.generate_products
    p = Spree::Product.create({ :name => "El Biki",
                                :description => "Cercano a la Universidad de La Habana, este pequeño restaurante-cafetería, ofrece un menú especialmente dirigido a    vegetarianos.",
                                :price => 0 })

    p.taxons<< [ Spree::Taxon.where(:name => "La Habana")[0], Spree::Taxon.where(:name => "Drinks")[0]]
    p.description.compact!

    p.available_on = Time.now
    p.save
  end

  def self.generate_hotels
    hotel = Spree::Product.create({ :name => "Hotel Melia Cohiba",
                                :description => "The 22-story Meliá Cohiba stands at a privileged intersection in Vedado’s commercial and leisure area. The hotel named after the famous Cohiba Cuban cigar brand, is located in the modern Vedado district of Havana and faces the Havana coastline with its renowned Malecón ocean drive.

Inside the hotel you will find 462 modern rooms (most with ocean and city view) designed for double and single occupancy, a spacious and elegant lobby with fountains, classical furnishings and panoramic windows. A wireless Wi-Fi Internet connection is available in the lobby, Royal Service VIP Bar and meeting rooms.

Guest have free access to the free-form fresh-water outdoors swimming pool with Jacuzzi and the wellness center with gym, topnotch equipment, weight lifting and aerobics. Massage service is available ($).

Meals and / or drinks can be enjoyed in the á la Carte, gourmet and buffet restaurants, bars or the cafeteria. Cigar connoisseurs will appreciate the elegant Cigar-Lounge & Shop/Humidor, Casa del Habano, which turns into the music-bar during the evenings. The Habana Café nightclub, the only one of its kind in the city, recreating Havana of the 50’s in a style similar to that of the world famous Hard Rock Café, serves dinner and international beverages.

People who choose to get married in Havana can make use of the services of the hotel’s wedding coordinator who will take care of all the details, provide attractive offers for ceremonies in the city and more.",
                                 :price => 0 })

    properties = "Lobby Bar
                Bar
                A la Carte Restaurant
                Cafeteria
                Cabaret
                Garden
                Shop
                Parking
                Fax Service
                Laundry
                Tour Booking Desk
                Swimming Pool
                Car Rental
                Currency Exchange
                Business Center
                Internet access in the lobby
                Lifts
                Conference Room
                Restaurant 	Business desk
                Hairdresser
                Wedding Legal Services
                Taxi
                Doctor on call
                Handicapped facilities
                Room Service
                Multilingual
                Staff
                24 Hour Reception
                Concierge Services
                Porter Bellman
                Wedding Services
                Catering for Events
                Smoking Areas
                Bar & Lounge
                Royal Club
                Servicio de Internet"

    properties = properties.split("\n").map{|s| s.strip}

    for property_name in properties
      p.properties << Spree::OpenerpLoader.find_or_create(Spree::Property, :name => property_name.to_url, :presentation => property_name )
    end

    p.taxons<< [ Spree::Taxon.where(:name => "La Habana")[0], Spree::Taxon.where(:name => "Acomodation")[0]]

    p.description.compact!

    p.available_on = Time.now
    p.save
    #..........................................................
    dic_options = {}
    dic_options.update({ "Meal Plan" => "Continental breakfast
                                         Modified American plan
                                         American plan" })

    dic_options.update({ "Season" => "From:01/05/2012  To:14/07/2012
                                      From:15/07/2012  To:24/08/2012
                                      From:25/08/2012  To:31/10/2012" })

    dic_options.update({ "Adult" => "1
                                     2
                                     3" })

    dic_options.update({ "Child" => "1
                                     2
                                     3" })

    dic_options.update({ "Infant" => "1
                                      2
                                      3" })

    for key in dic_options.keys
      dic_options[key] = dic_options[key].split("\n").map{|e| e.strip}
    end

    #....................Melia Cohiba Rooms.....................

    rooms = {}
    rooms.update({ "Hotel Melia Cohiba" =>"Lobby Bar
                                            Bar
                                            A la Carte Restaurant
                                            Cafeteria
                                            Cabaret
                                            Garden
                                            Shop
                                            Parking
                                            Fax Service
                                            Laundry
                                            Tour Booking Desk
                                            Swimming Pool
                                            Car Rental
                                            Currency Exchange
                                            Business Center
                                            Internet access in the lobby
                                            Lifts
                                            Conference Room
                                            Restaurant 	Business desk
                                            Hairdresser
                                            Wedding Legal Services
                                            Taxi
                                            Doctor on call
                                            Handicapped facilities
                                            Room Service
                                            Multilingual
                                            Staff
                                            24 Hour Reception
                                            Concierge Services
                                            Porter Bellman
                                            Wedding Services
                                            Catering for Events
                                            Smoking Areas
                                            Bar & Lounge
                                            Royal Club
                                            Servicio de Internet" })

    rooms.update({"Standard Room" =>"Air Conditioning
                                      Phone
                                      Satellite TV
                                      Safety Deposit Box
                                      Room Service
                                      Hair Dryer
                                      Minibar
                                      Private Bathroom
                                      Cold & hot water
                                      Amenity Kit" })

    rooms.update({"Junior Suite Room" =>"Air Conditioning
                                        Phone
                                        Satellite TV
                                        Safety Deposit Box
                                        Room Service
                                        Hair Dryer
                                        Minibar
                                        Private Bathroom
                                        Bath Robes
                                        Baby Cribs (On request)
                                        Power 220V/60Hz
                                        Cold & hot water
                                        Amenity Kit
                                        Bathroom with WC and Shower
                                        Phone
                                        Satellite TV
                                        Safety Deposit Box
                                        Room Service
                                        Hair Dryer
                                        Minibar
                                        Private Bathroom
                                        Bath Robes
                                        Baby Cribs (On request)
                                        Power 220V/60Hz
                                        Cold & hot water
                                        Amenity Kit
                                        Bathroom with WC and Shower" })

    rooms.update({"Standard Royal Service Room" =>"Air Conditioning
                                                    Phone
                                                    Satellite TV
                                                    Safety Deposit Box
                                                    Room Service
                                                    Hair Dryer
                                                    Minibar
                                                    Baby Cribs (On request)
                                                    Power 220V/60Hz
                                                    Cold & hot water
                                                    Bathroom with WC and Shower
                                                    Royal Service" })

    rooms.update({"Suite Room" =>"Air Conditioning
                                  Phone
                                  Satellite TV
                                  Safety Deposit Box
                                  Room Service
                                  Hair Dryer
                                  Private Bathroom
                                  Bath Robes
                                  Baby Cribs (On request)
                                  Power 220V/60Hz
                                  Cold & hot water
                                  Amenity Kit
                                  Bathroom with WC and Shower" })

    rooms.update({"Junior Suite Royal Service Room" =>"Air Conditioning
                                                Phone
                                                Satellite TV
                                                Safety Deposit Box
                                                Room Service
                                                Hair Dryer
                                                Private Bathroom
                                                Sea View
                                                Iron and Iron Board
                                                Coffee Maker
                                                Bath Robes
                                                Baby Cribs (On request)
                                                Power 220V/60Hz
                                                Cold & hot water
                                                Amenity Kit
                                                Concierge service
                                                Minibar replenished daily
                                                Private Check-in
                                                Internet Access
                                                Bathroom with WC and Shower
                                                Royal Service
                                                Living Room
                                                Wake up service
                                                Telephone
                                                Climat Control
                                                Make-up Mirror
                                                Telephone in Bathroom
                                                VIP amenities in the room
                                                Pillow Menu" })
    for key in rooms.keys
      rooms[key] = rooms[key].split("\n").map{|e| e.strip}.compact!
    end

    for r in rooms.keys
      p = Spree::Product.create({ :name =>r,:price => 0 })
      properties = dic.split("\n").map{|s| s.strip!}
      property_type = if r == rooms.first then "Hotel Amenity" else "Room Amenity" end
      assign_property(properties, p, property_type)
      p.taxons<< [ Spree::Taxon.where(:name => "La Habana")[0], Spree::Taxon.where(:name => "Acomodation")[0]]
      p.description.compact!
      p.available_on = Time.now
      p.save
      self.option_and_variant(dic_options, p)
    end

  end

  def assign_property(dic, p, property_type_name)
    property_type = Spree::PropertyType.create({:name => property_type_name.to_url, :show => property_type_name})
    for property_name in dic
      p.properties << Spree::OpenerpLoader.find_or_create(Spree::Property, :name => property_name.to_url, :presentation => property_name,
                                                          :property_type_id => property_type.id)
    end

  end

  def self.option_and_variant(dic_options, p)
    p.option_types = []
    p.variants =[]
    i = 1
    for key in dic_options.keys
      option_type =  Spree::OpenerpLoader.find_or_create(Spree::OptionType, :name => key.to_url, :presentation => key, :position => i )
      i +=1
      p.option_types << option_type
    end

    variants =  comb(dic_options.values)
    for var in variants
      vc = Spree::Variant.create(:product_id => p.id, :price => rand(100), :position => 1)
      vc.option_values = []
      j = 1
      for value in var
        vc.option_values << Spree::OpenerpLoader.find_or_create(Spree::OptionValue, :name => value.to_url, :presentation => value, :position => j )
        j+= 1
        vc.save
      end
    end
    p.save
  end

  def self.comb(a)
    return a if a.length <=1
    first = a.shift
    combs = comb(a)
    result = []
    for elem in first
      for r in combs
        result << r + [elem]
      end
    end
    result
  end

end



