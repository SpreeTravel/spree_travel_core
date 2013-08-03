# -*- coding: utf-8 -*-
class Constant

  def self.continenal_breakfast
    continental_breakfast = Spree::OptionValue.where(:name => 'meal-plan-continental-breakfast').first
    default_meal_plan_id = Spree::OptionValue.where(:option_type_id => Spree::OptionType.find_by_name('meal-plan').id).first.id
    continental_id = continental_breakfast ? continental_breakfast.id : default_meal_plan_id
    continental_id
  end

  def self.automatic_transmission
    automatic_transmission = Spree::OptionValue.where(:name => 'transmission-automatic').first
    default_transmission_id = Spree::OptionValue.where(:option_type_id => Spree::OptionType.find_by_name('transmission').id).first.id
    automatic_id = automatic_transmission ? automatic_transmission.id : default_transmission_id
    automatic_id
  end

  def self.standard_confort
    standard_confort = Spree::OptionValue.where(:name => 'taxi-confort-standard').first
    default_confort_id = Spree::OptionValue.where(:option_type_id => Spree::OptionType.find_by_name('taxi-confort').id).first.id
    standard_id = standard_confort ? standard_confort.id : default_confort_id
    standard_id
  end

  DEFAULT_ADULTS_PROGRAM          = 1
  DEFAULT_CHILDREN_PROGRAM        = 0
  DEFAULT_INFANTS_PROGRAM         = 0
  def self.DEFAULT_DATE_PROGRAM; Time.now.to_date + 2 end

  def self.DEFAULT_CHECK_IN_ACCOMMODATION; Time.now.to_date + 1 end
  def self.DEFAULT_CHECK_OUT_ACCOMMODATION; Time.now.to_date + 2 end
  DEFAULT_ADULTS_ACCOMMODATION    = 2
  DEFAULT_CHILDREN_ACCOMMODATION  = 0
  DEFAULT_INFANTS_ACCOMMODATION   = 0
  def self.DEFAULT_MEAL_PLAN_ACCOMMODATION; Constant.continenal_breakfast; end

  def self.DEFAULT_INIT_DATE_RENT; Time.now.to_date + 1 end
  def self.DEFAULT_END_DATE_RENT; Time.now.to_date + 4 end
  def self.DEFAULT_TRANSMISSION_RENT; self.automatic_transmission; end

  def self.DEFAULT_INIT_DATE_TRANSFER; Time.now.to_date + 1 end
  def self.DEFAULT_END_DATE_TRANSFER; Time.now.to_date + 2 end
  DEFAULT_ADULTS_TRANSFER         = 1
  DEFAULT_CHILDREN_TRANSFER       = 0
  DEFAULT_INFANTS_TRANSFER        = 0
  def self.DEFAULT_CONFORT_TRANSFER; self.standard_confort; end
  DEFAULT_TRIP_TYPE_TRANSFER      = 'trip-one-way'

  def self.DEFAULT_INIT_DATE_FLIGHT; Time.now.to_date + 1 end
  def self.DEFAULT_END_DATE_FLIGHT; Time.now.to_date + 7 end
  DEFAULT_ADULTS_FLIGHT           = 1
  DEFAULT_CHILDREN_FLIGHT         = 0
  DEFAULT_INFANTS_FLIGHT          = 0

  DATE_FORMAT = '%Y-%m-%d'

  SOLR_FIELDS = [:name, :description, :is_active, :taxon_ids, :price_range, :recomended, :updated_at, :price]
  SOLR_FACETS = [:price_range, :taxon_names]

  SORT_FIELDS = {
    "price_asc"         => ["spree_variants.price",        "asc"],
    "price_desc"        => ["spree_variants.price",        "desc"],
    "date_asc"          => ["spree_products.available_on", "asc"],
    "date_desc"         => ["spree_products.available_on", "desc"],
    "name_asc"          => ["spree_products.name",         "asc"],
    "name_desc"         => ["spree_products.name",         "desc"],
    "updated_desc"      => ["spree_products.updated_at",  "desc"],
    "recomended_desc"   => ["spree_products.recomended",  "desc"]
  }

  PLAN_ALIMENTICIO      = 'meal_plan_type'
  MAIN_PACKAGE          = 'is_main_part_of_package'
  MAIN_HOTEL            = 'is_main_part_of_hotel'

  PART_OF_PACKAGE       = 'is_part_of_package'
  PART_OF_HOTEL         = 'is_part_of_hotel'

  POINT_OF_INTEREST     = 'ís_point_of_interest'
  MAX_RELATION          = 100

  ALL_PRODUCTS          = 'All products'
  #ALL_PRODUCTS         = 'Categories'
  ROUTES                = 'Routes'
  SITE                  = 'Site'
  DESTINATIONS          = 'Destinations'
  FLIGHT_DESTINATIONS   = 'Flight Place'
  ACCOMMODATION         = 'Accommodation'
  TOURS                 = 'Tours'

  # TODO: IMPORTANTE: quitar los ID y poner otra cosa aqui
  DESTINATIONS_TAXONOMY_ID = '758334403'
  SITES_TAXONOMY_ID        = '566279582'

  TYPE_PRODUCT          = "product"
  TYPE_FAMILY           = "family"
  TYPE_PACKAGE          = "package"
  TYPE_INTEREST_POINT   = "interest_point"
  TYPE_ROUTE            = "route"
  TYPE_DESTINATION      = "destination"

  IS_PART_OF_HOTEL          = "is_part_of_hotel"
  IS_PART_OF_RENT_A_CAR     = "is_part_of_rent_a_car"
  IS_PART_OF_PACKAGE        = "is_part_of_package"
  IS_PART_OF_TRANSFER       = "is_part_of_transfer"
  IS_PART_OF_DESTINATION    = "is_part_of_destination"
  IS_PART_OF_INTEREST       = "is_point_of_interest"
  IS_MAIN_PART_OF_PACKAGE   = "is_main_part_of_package"

  CATEGORY_PRODUCT_HOTEL    = "Accommodation"
  CATEGORY_PRODUCT_RENT_CAR = "Rent Car"
  CATEGORY_PRODUCT_TRANSFER = "Transfer"

  DIC_TRANSLATES = {
    :Product       => [:name, :description, :meta_description, :meta_keywords],
    :Taxon         => [:name, :description],
    :Taxonomy      => [:name],
    :Prototype     => [:name],
    :Property      => [:presentation],
    :OptionType    => [:presentation],
    :OptionValue   => [:presentation],
    :OptionType    => [:presentation]
  }
  DIC_MODELS = {
    :interest_point => :JafResourceTemplate,
    :products       => :JafProductTemplate,
    :package        => :JafProductSupplier,
    :family         => :JafFamily,
    :route          => :JafRoute,
    :destination    => :JafDestination
  }

  def Constant.initialize_relation_types
    Spree::RelationType.create(:name => 'is_part_of_hotel', 		:applies_to => 'Spree::Product')
    Spree::RelationType.create(:name => 'is_part_of_rent_a_car', 	:applies_to => 'Spree::Product')
    Spree::RelationType.create(:name => 'is_part_of_package', 		:applies_to => 'Spree::Product')
    Spree::RelationType.create(:name => 'is_main_part_of_package', 	:applies_to => 'Spree::Product')
    Spree::RelationType.create(:name => 'is_part_of_transfer', 		:applies_to => 'Spree::Product')
    Spree::RelationType.create(:name => 'is_part_of_destination', 	:applies_to => 'Spree::Product')
    Spree::RelationType.create(:name => 'is_point_of_interest', 	:applies_to => 'Spree::Product')
  end

end
