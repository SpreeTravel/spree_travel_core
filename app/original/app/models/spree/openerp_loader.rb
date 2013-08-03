class Spree::OpenerpLoader

  def self.find_or_create(klass, options = {})
    relation = klass
    for key in options.keys
      relation = relation.where(key => options[key])
    end
    object = if relation.length == 0 then klass.create(options) else relation.first end
    object
  end

  def self.import_category (elems, consts = {})
    taxonomy = self.find_or_create(Spree::Taxonomy, :name => consts[:const])
    self.import_taxonomy(elems, taxonomy)
  end

  def self.import_taxonomy (collection, taxonomy)
    while elem = collection.first
	  stack = []
	  while elem
		stack <<  if taxonomy.name == Constant::DESTINATIONS then elem.place_id.option_id.name else elem.name end
		collection.delete(elem)
		elem = elem.parent_id
	  end
	  stack.pop  if taxon = Spree::Taxon.where( :name  =>  stack.last)[0]
	  while name = stack.pop
		taxonomy_id = taxonomy.id
		taxon = self.find_or_create(Spree::Taxon, :name => name, :parent_id => taxon && taxon.id, :taxonomy_id => taxonomy_id)
	  end
    end
  end

  def self.translate_all(lang)
    dic_models = Constant::DIC_TRANSLATES
    for model in dic_models.keys
      objs = "Spree::#{model}".constantize.send(:all)
      objs.each do |obj|
        dic_models[model].each{ |method| translate(lang, obj, method, obj.send(method))}
      end
    end
  end

  def self.translate(new_lang, obj, method, src)
	default_lang = I18n.locale
   	I18n.locale = new_lang
    if n = IrTranslation.find(:first,domain=>[['type','=','model'],['src', '=', src],['lang','=','es_ES']])
   	  src_translate = n.value
	  else
      src_translate = src
	  end
  	obj.update_attribute(method, src_translate)
  	I18n.locale = default_lang
  	puts '//' + obj.name + '//' + method.inspect  + '//' + src_translate
  end

  # this methods is deprecated
  def self.extend_taxonomies
    self.product_taxonomy = Spree::Taxonomy.where( :name  =>  Constant::ALL_PRODUCTS)[0]
    self.site_taxonomy = Spree::Taxonomy.where( :name  =>  Constant::SITE)[0]
    self.route_taxonomy = Spree::Taxonomy.where( :name  =>  Constant::ROUTES)[0]
    self.extend_taxnomy(product_taxonomy) if product_taxonomy
    self.extend_taxnomy(site_taxonomy)    if site_taxonomy
    self.extend_taxnomy(route_taxonomy)   if route_taxonomy
  end

  def self.extend_taxnomy(taxonomy)
    destination_taxonomy = Spree::Taxonomy.where( :name  =>  Constant::DESTINATIONS)[0]
    array_leaf = taxonomy.taxons.reject!{ |taxon| not taxon.children.blank? }
	  array_leaf.each{|leaf| self.ext(destination_taxonomy.taxons[1], leaf,taxonomy)}
  end

  def self.ext(taxon_dest, parent, taxonomy)
	taxon = self.find_or_create(Spree::Taxon,:name => taxon_dest.name,:parent_id => parent.id,:taxonomy_id => taxonomy.id)
	taxon_dest.children.each{|e| self.ext(e,taxon,taxonomy)}
	taxon
  end

  ## Import elements of OpenErp that will be products in Spree ###

  # TODO: ver ref
  def self.find_or_create_product(elem, type)
    name = if type == Constant::TYPE_DESTINATION then elem.place_id.option_id.name else elem.name end
    p = Spree::Product.where( :name  =>  name)[0]
    return p unless p.nil? or p.available_on.nil?
	  sku = case type
		      when Constant::TYPE_FAMILY, Constant::TYPE_INTEREST_POINT then elem.default_code
		      when Constant::TYPE_ROUTE, Constant::TYPE_DESTINATION     then elem.code
		      when Constant::TYPE_PACKAGE, Constant::TYPE_PRODUCT       then elem.template_code
		      end
	  p = Spree::Product.create :name => name,:sku=>sku, :description=>elem.description, :price => rand(90)+10,
                              :meta_description=>elem.meta_description,:meta_keywords => elem.meta_keywords
    taxons = []
	  taxons =  [self.get_taxons(elem, type)[:d_taxon]] if [self.get_taxons(elem, type)[:d_taxon]]
    taxons += [self.get_taxons(elem, type)[:p_taxon]] unless  type == Constant::TYPE_DESTINATION
    taxons.compact!

	  p.taxons << taxons if type == Constant::TYPE_INTEREST_POINT or Constant::TYPE_DESTINATION or Constant::TYPE_FAMILY or
                                  Constant::TYPE_PACKAGE or (Constant::TYPE_PRODUCT and elem.categ_id.parent_id.name == Constant::TOURS)

    case type
    when Constant::TYPE_PRODUCT, Constant::TYPE_FAMILY
      if !elem.ref_id.nil?
        true
        #p:latitude=>elem.ref_id.address.longitude
        #p:longitude => elem.ref_id.address.longitude
        #p.save
      end
    when Constant::TYPE_INTEREST_POINT
      true
      #p:latitude=>elem.address.longitude
      #p:longitude => elem.address.longitude
      #p.save
    end
    p.available_on = Time.now
    p.save
    p
  end

  #def self.method_missing(name, *args)
  # #unless super(name, *args)
	 # dic_models = Constant::DIC_MODELS
  #  if dic_models.keys.detected name and arg.length ==1
  #    puts '/////////////////////////// llego a method_missing'
  #    model = dic_models[name]
  #    objs = model.constantize.send(:all)
  #    objs.each { |obj| obj.send("import_::#{name}", arg[0]) }
  #  end
  #end

  def self.import_all_family
    JafFamily.all.each { |elem|  self.import_family(elem)}
  end

  def self.import_all_interest_point
    JafResourceTemplate.all.each { |elem| self.import_interest_point(elem) }
  end

  def self.import_all_destination
    JafDestination.all.each { |elem| self.import_destination(elem)   }
  end

  def self.import_all_route
    JafRoute.all.each {|elem| self.import_route(elem) }
  end

  def self.import_all_package
    JafProductSupplier.all.each { |elem| self.import_package elem }
  end

  def  self.import_all_products
    JafProductTemplate.all.each{|elem| self.import_product(elem)}
  end

  def self.import_family(elem)
	  p = self.find_or_create_product(elem, Constant::TYPE_FAMILY)
	  self.related(elem, Constant::TYPE_FAMILY)
    self.properties(p,elem, Constant::TYPE_FAMILY, :description_properties)
  end

  def self.import_interest_point(elem)
    p = self.find_or_create_product(elem, Constant::TYPE_INTEREST_POINT)
    self.properties(p,elem, Constant::TYPE_INTEREST_POINT, :description_properties)
  end

  def self.import_destination(elem)
    unless elem.name == Constant::DESTINATIONS
      p = self.find_or_create_product(elem,Constant::TYPE_DESTINATION)
      self.related(elem, Constant::TYPE_DESTINATION)
      self.properties(p,elem, Constant::TYPE_DESTINATION, :description_properties)
    end
  end

  def self.import_route(elem)
    p = self.find_or_create_product(elem, Constant::TYPE_ROUTE)
    #self.related(elem, Constant::TYPE_ROUTE)
    self.properties(p,elem, Constant::TYPE_ROUTE, :description_properties)
  end

  def self.import_package(elem)
    if elem.supp_type == Constant::TYPE_PACKAGE
      p = self.find_or_create_product(elem, Constant::TYPE_PACKAGE)
      self.related(elem, Constant::TYPE_PACKAGE)
      self.properties(p,elem, Constant::TYPE_PACKAGE, :description_properties)
    end
  end

  def  self.import_product(elem)
    p = self.find_or_create_product(elem, Constant::TYPE_PRODUCT)
    self.related(elem, Constant::TYPE_PRODUCT)
    self.properties(p,elem, Constant::TYPE_PRODUCT, :description_properties)
    self.properties(p,elem, Constant::TYPE_PRODUCT, :variant_properties)
    self.option_context(p,elem)
  end


  def self.option_context(p, elem)
    array_option_types =[]
    product_prices = elem.seller_info_id.pricelist_ids
    return if product_prices.empty?
	  product_prices.each do |p_price|
        if p_price.min_quantity == 1

          #///////// Context Use //////////////
          options_context = []
          context_use = p_price.context_id
          context_use.value_ids.each do |value|
          opts_context = self.create_option(p, value, value.dimension_instance_id.name, value.name.to_i)
          options_context << opts_context['option']
          array_option_types << opts_context['option_type']
          end

          #///////// Variants //////////////
          options= []
          template_values = p_price.product_id.product_tmpl_id.jpt_id.value_extended_id_ids
          product_values =  p_price.product_id.value_extended_id_ids
          variants = product_values - template_values
          variants.each do  |variant|
          dim = 'Add'
          dim = variant.dim_instance_id.name
          opts = self.create_option_season(p,variant.name, dim, 10)
          options << opts['option']
          array_option_types << opts['option_type']
          end

          #///////// Season //////////////
          options_season = []
          season = p_price.season_id.name + ": "
          season += p_price.season_id.start_date.to_s + " - "
          season += p_price.season_id.end_date.to_s
          opts_season = self.create_option_season(p,season, 'Season')
          options_season << opts_season['option']
          array_option_types << opts_season['option_type']

          #////////////// Create Spree Variant //////////////
          unless options_context.blank? or  options_season.blank? or options.blank?
            vc = Spree::Variant.create(:product_id => p.id, :sku =>p.name.hash.abs, :price => p_price.price, :position => 1)
                           #, :position =>p.variants.length
            vc.option_values = options_context unless options_context.blank?
            vc.option_values += options unless options.blank?
            vc.option_values += options_season unless options_season.blank?
            vc.option_values.uniq!
            vc.save
          end
        end
      end
      array_option_types.uniq!
      p.option_types||= if p.option_types.blank? then array_option_types else p.option_types + array_option_types end
      p.option_types.uniq!
      p.product_option_types.uniq!
      p.save
      p
  end

  def self.create_option(product, value, name='', pos=0 )
    name_option_type = value.dimension_instance_id.name
    #value.options_id.parent_id.name
    #JafDimension.find(:first, :domain => [['use','=' ,'place' ]])
    name =  '-' + name  unless name.blank?
    name_option_value= value.name #+ name
    option_type = self.find_or_create(Spree::OptionType, :name => name_option_type.to_url,:presentation => name_option_type)
    self.find_or_create(Spree::ProductOptionType,:option_type_id => option_type.id,:product_id => product.id)
    val = self.find_or_create(Spree::OptionValue,:name => name_option_value.to_url,:presentation => name_option_value,
                              :option_type_id =>  option_type.id)
    val.position = pos
    val.save
    return {'option' => val, 'option_type'=> option_type }
  end

  def self.create_option_season(product, value_name, name='', pos=0 )
    puts "/////////////////se est'a creando una option de un vantiante para #{name}" unless name== 'Season'
    name_option_type = name
    option_type = self.find_or_create(Spree::OptionType,:name => name_option_type,:presentation => name_option_type)
    self.find_or_create(Spree::ProductOptionType,:option_type_id => option_type.id,:product_id => product.id)
    val = self.find_or_create(Spree::OptionValue,:name => value_name.to_url,:presentation => value_name,:option_type_id =>  option_type.id)
    val.position = pos
    val.save
    return {'option' => val, 'option_type'=> option_type }
  end

  #this properties are about variant
  def self.properties(product, elem, type_model, type_property)
    return unless type_model == Constant::TYPE_FAMILY or Constant::TYPE_PRODUCT or Constant::TYPE_PACKAGE
    properties = case type_property
                 when :variant_properties      then elem.value_extended_id_ids.map   { |value| self.create_property(value)['property'] }
                 when :description_properties  then elem.value_extended_desc_ids.map { |value| self.create_property(value)['property'] }
                 end

    properties.uniq!
    properties.each {|prop| self.find_or_create(Spree::ProductProperty,:property_id => prop.id,:product_id => product.id,:value => type_property)}
  end

  def self.create_property(value, name='')
    name_property_type = value.dimension_id.name
    name_property = value.option_id.name + name
    property_type = self.find_or_create(Spree::Property, :name => name_property_type.to_url)
    property = self.find_or_create(Spree::Property,:name => name_property.to_url,:presentation => name_property,
                                   :property_type_id => property_type.id)
    return {'property' => property, 'property_type'=> property_type }
  end

  def self.relat(related_to, relatable, relation_type)
    return unless p_spree = Spree::Product.where( :name  =>  relatable.name)[0]
    e_spree = Spree::Product.where(:name => related_to.name)[0]
    relation = Spree::RelationType.where( :name  =>  relation_type)[0]
    Spree::Relation.create( :relatable => p_spree, :related_to => e_spree, :relation_type => relation)
  end


  def self.related(elem, type)
    relation = if type == Constant::TYPE_FAMILY or Constant::TYPE_PRODUCT  then Constant::IS_PART_OF_INTEREST
               elsif  self.package?(elem)                                  then Constant::IS_PART_OF_PACKAGE
               elsif type == Constant::DESTINATIONS                        then Constant::IS_PART_OF_DESTINATION
               end
    elem.ref_ids.each{|e| self.relat(elem, e, relation)}

    if type == Constant::TYPE_FAMILY #type == Constant::TYPE_PRODUCT
      relation =  case elem.categ_id.name
				          when Constant::CATEGORY_PRODUCT_HOTEL    then Constant::IS_PART_OF_HOTEL
                  when Constant::CATEGORY_PRODUCT_RENT_CAR then Constant::IS_PART_OF_RENT_A_CAR
                  when Constant::CATEGORY_PRODUCT_TRANSFER then Constant::IS_PART_OF_TRANSFER
				          end
      elem.template_ids.each{ |e| self.relat(elem, e, relation)}
    end
  end

  def self.package?(elem)
    false
  end

  def self.get_taxons(elem, type)
    result = []
    plink =''
    dlink = nil

    case type
    when Constant::TYPE_PRODUCT, Constant::TYPE_FAMILY, Constant::TYPE_PACKAGE
      if elem and elem.ref_id and not elem.ref_id.place_parent_id.nil?
        item = elem.ref_id.place_parent_id.option_id
        d_stack = self.parents(item)
        dlink =  d_stack.map { |e| e.to_url}.reverse.join('/') unless elem.ref_id.nil? || elem.ref_id.place_parent_id.nil?
      end
      plink = "#{Constant::ALL_PRODUCTS.to_url}/" + elem.categ_id.complete_name.split('/').map{ |e| e.to_url}.join('/')
      result = {:d_taxon => Spree::Taxon.find_by_permalink(dlink),:p_taxon => Spree::Taxon.find_by_permalink(plink)}
    when Constant::TYPE_INTEREST_POINT
      if elem and elem.place_parent_id and not elem.place_parent_id.nil?
        item = elem.place_parent_id.option_id
        d_stack = self.parents(item)
        dlink = d_stack.map { |e| e.to_url}.reverse.join('/')
      end
      plink = elem.category_id.complete_name.split('/').map{|e|e.to_url}.join('/')
      result = {:d_taxon => Spree::Taxon.find_by_permalink(dlink),:p_taxon => Spree::Taxon.find_by_permalink(plink)}
    when Constant::TYPE_DESTINATION
      item = elem
      d_stack = self.parents(item)
      dlink = d_stack.map { |e| e.to_url }.reverse.join('/')
      result = {:d_taxon => Spree::Taxon.find_by_permalink(dlink)}
    end
    result
  end

  def self.plink(elemens)
     dest_name = elemens.map { |e| e.to_url}.reverse.join('/')
     split_name = elemens.categ_id.complete_name.split('/')
     complete_name = split_name.map { |e| e.to_url}.join('/') + '/'
     plink = complete_name + dest_name
  end

  def self.parents(item)
    result = []
	  while item = item.parent_id
        result << item.name
    end
    result
  end

  def self.import_all_taxonomies
    self.import_category(JafDestination.all,     :const => Constant::DESTINATIONS )
    self.import_category(ProductCategory.all,    :const => Constant::ALL_PRODUCTS)
    #self.import_category(JafRouteCategory.all,  :const => Constant::ROUTES)
    self.import_category(JafResourceCategory.all,:const => Constant::SITE)
    #self.extend_taxonomies
    #self.translate_taxonomies('es_ES')
  end

  def self.import_all_all_products
    self.import_all_destination
    self.import_all_interest_point
    self.import_all_products
    self.import_all_package
    self.import_all_family
    #self.import_route

  end

  def self.import_openerp
    self.import_all_taxonomies
    self.import_all_all_products
  end

  def self.delete_all
    self.delete_taxonomies
    self.delete_products
  end

  def self.delete_taxonomies
	Spree::Taxonomy.all.each{|e| e.translations.delete_all }
    Spree::Taxonomy.delete_all
    #:spree_taxon_translations_table.delete_all
    
    Spree::Taxon.delete_all
    #Spree::TaxonTranslation.delete_all
  end

  def self.delete_products
	Spree::Property.all.each{|e| e.translations.delete_all }
    Spree::Property.delete_all
    
    Spree::ProductOptionType.delete_all
    Spree::OptionType.all.each{|e| e.translations.delete_all }
    Spree::OptionType.delete_all    
    
    #Spree::OptionTypePrototype.delete_all
    #Spree::PropertyPrototype.delete_all
    Spree::Prototype.all.each{|e| e.translations.delete_all }
    Spree::Prototype.delete_all
    #Spree::PrototypeTranslation.delete_all
    #Spree::OptionTypePrototypeTranslation.delete_all
    Spree::OptionValue.all.each{|e| e.translations.delete_all }
    Spree::OptionValue.delete_all
    #Spree::OptionValueTranslation.delete_all
    #Spree::OptionValueVariant.delete_all
    Spree::Product.all.each{|e| e.translations.delete_all }
    Spree::Product.delete_all
    #Spree::ProductTranslation.delete_all
    Spree::Variant.delete_all
    Spree::ProductProperty.delete_all
    Spree::PropertyType.delete_all
    Spree::Relation.delete_all
    Spree::ProductOptionType.delete_all
    Spree::ProductGroup.delete_all
  end


  def self.emulate_seed

#Taxonomies
    Spree::Taxonomy.create([{ :name => Constant::DESTINATIONS },
                            { :name => Constant::SITE },
                            { :name => Constant::ALL_PRODUCTS }
                           ])

  end


  def rand_latitud
    array = [23.1055, 23.105,  23.1045, 23.104, 23.1035, 23.103,
             23.1025, 23.102,  23.1015, 23.101, 23.1005, 23.1,
             23.0995, 23.099,  23.0985, 23.098, 23.0975, 23.097,
             23.0965, 23.096,  23.0955, 23.095, 23.0945, 23.094 ]
    array[rand(array.length)]
  end

  def rand_longitud
    array = [-82.4431,  -82.4443,   -82.4455,   -82.4467, -82.4479,
             -82.4503,	-82.4515,	  -82.4527,	  -82.4539, -82.4551,
             -82.4563,	-82.4575,	  -82.4587,	  -82.4599, -82.4611,
             -82.4623,	-82.4635,	  -82.4647,	  -82.4659, -82.4671,
             -82.4683,	-82.4695,	  -82.4707,   -82.4491]
    array[rand(array.length)]
  end

  def self.export_user_to_openerp(address)
    name = address.firstname + ' ' + address.lastname
    partner_id = ResPartner.search([['name','=',name]])[0] unless ResPartner.search([['name','=',name]])
    new_partner_id = ResPartner.create(:name => name,:active => true) unless partner_id

    #if new_partner_id
    #  partner_id = new_partner_id
    #
    #  country = address.country.name
    #  country_id = ResCountry.search([['name' , '=' , country]])[0]  unless country.blank?
    #  #state_id = nil
    #  #state_id =  ResCountryState.search([['name', '=' , add.state_name]])[0] unless add.state_name.blank?
    #  #
    #  #unless  state_id
    #  #  state_id =  ResCountryState.create(:name => add.state_name, :code => 12, :country_id =>country_id )
    #  #end
    #
    #  ResPartnerAddress.create(:partner_id => partner_id,
    #                           :street => address.address1,
    #                           :street2 => address.address2,
    #                           #:email =>email,
    #                           :phone => address.phone,
    #                           :city => address.city,
    #                           :country_id => country_id,
    #                           :zip => address.zipcode
    #  #:state_id => state_id,
    #  )
    #
    #end
  end

  def self.export_all_user_to_openerp(params)
    params.each{|address| export_user_to_openerp(address)}
  end

  def self.export_sale_order_to_openerp
    o = SaleOrder.create(:partner_id => ResPartner.search([['name', 'ilike','Agrolait']])[0],
                         :partner_order_id => 1,
                         :partner_invoice_id => 1,
                         :partner_shipping_id => 1,
                         :pricelist_id => 1)

    # so = SaleOrder.new
    # so.on_change('onchange_partner_id', :partner_id, 1, 1, false)
    #auto-complete the address and other data based on the partner
    # so.order_line = [SaleOrderLine.new(:name => 'sl1',:product_id => 1,:price_unit => 42,:product_uom => 1)]#create one order line
    # so.save
    # so.amount_total
    # => 42.0

    #generar la factura --AccountInvoice
    #generar los pasajeros --JafPassanger
  end

  def export_contact
    true
  end


end

