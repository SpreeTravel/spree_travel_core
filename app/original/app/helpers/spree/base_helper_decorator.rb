Spree::BaseHelper.class_eval do

  Spree::Image.attachment_definitions[:attachment][:styles].each do |style, v|
    define_method "#{style}_image" do |product, *options|
      options = options.first || {}
      if product.images.empty?
        if product.hotel?
          image_tag "store/no_imagen_72x72.png", options
        elsif product.room?
          image_tag "store/no_imagen_72x72.png", options
        elsif product.package?
          image_tag "store/no_imagen_72x72.png", options
        elsif product.part_of_package?
          image_tag "store/no_imagen_72x72.png", options
        elsif product.transfer?
          image_tag "store/no_imagen_72x72.png", options
        elsif product.part_of_transfer?
          image_tag "store/no_imagen_72x72.png", options
        elsif product.rent_a_car?
          image_tag "store/no_imagen_72x72.png", options
        elsif product.car?
          image_tag "store/no_imagen_72x72.png", options
        elsif product.destination?
          image_tag "store/no_imagen_72x72.png", options
        elsif product.part_of_destination?
          image_tag "store/no_imagen_72x72.png", options
        elsif product.route?
          image_tag "store/no_imagen_72x72.png", options
        elsif product.part_of_route?
          image_tag "store/no_imagen_72x72.png", options
        else
          image_tag "store/no_imagen_72x72.png", options
        end
      else
        image = product.images.first
        options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
        image_tag image.attachment.url(style), options
      end
    end
  end

  def price(price)
    number_to_currency (price), :precision=>0
  end

  def price_with_context(product, params)
    p = product.price_with_context(params)
    price(p) if p > 0
  end

  def variant_and_price_with_context(product, params, type="")
    if type == "programs"
      data_context = product.variant_and_price_for_program(params)
      if params["you_search"].nil?  && !data_context["price"].nil?
         days = get_property_value(product, "programs-days").to_i
         data_context["price"] = data_context["price"] / days if days > 1
         data_context["price"] = data_context["price"] / params[:adults_program] if params[:adults_program]
         params["info"] = t('price_per_person_per_day')
      end
    elsif type == "tours"
      data_context = product.variant_and_price_for_tour(params)
      if params["you_search"].nil?  && !data_context["price"].nil?
        days = get_property_value(product, "tours-days").to_i
        data_context["price"] = data_context["price"] / days if days > 1
        params["info"] = t('price_per_person_per_day')
      end
    elsif type == "accommodation"
      data_context = product.variant_and_price_for_hotel(params)
      if params["you_search"].nil?  && !data_context["price"].nil?
        data_context["price"] = data_context["price"] / 2
        params["info"] = t('price_per_person_per_day')
      end
    elsif type == "room"
      data_context = product.variant_and_price_for_room(params)
      if params["you_search"].nil?  && !data_context["price"].nil?
        data_context["price"] = data_context["price"] / 2
        params["info"] = t('price_per_person_per_day')
      end
    elsif type == "flight"
      data_context = product.variant_and_price_for_flight(params)
    elsif type == "transfer"
      data_context = product.variant_and_price_for_transfer(params)
    elsif type == "rent"
      data_context = product.variant_and_price_for_rent(params)
      if params["you_search"].nil?  && !data_context["price"].nil?
        check_in = Constant.DEFAULT_INIT_DATE_RENT.to_date
        check_out = Constant.DEFAULT_END_DATE_RENT.to_date
        duration = check_out - check_in
        data_context["price"] = data_context["price"] / duration
        params["info"] = t('price_per_day')
      end
    else
      data_context = product.variant_and_price_with_context(params)
    end
    p = data_context['price']
    if p > 0
      data_context['price'] = price(p)
      data_context
    end
  end

  def color_id
    if @taxon.nil?
      "header-pages"
    else
      "taxon_page"
    end
  end

  #Este es de la p'aguina Home'
  def opinion(count)
    if count > 1
      t('opinions')
    else
      t('opinion')
    end
  end

  def other_ancestors(taxon)
    bad_permalinks = ['categories']
    t = taxon
    ancestors = []
    while(t.parent_id?)
      ancestors << t.parent if !bad_permalinks.include?(t.parent.permalink)
      t = t.parent
    end
    ancestors = ancestors.reverse
    ancestors
  end

  def first_child_destination(taxon)
    child = Spree::Taxon.where(:parent_id => taxon.id).first
    child
  end

  # TODO: revisar este metodo que esta un poco en candel
  def breadcrumbs(taxon, product, separator="&nbsp;&gt;&nbsp;")
    separator = raw(separator)
    crumbs = [content_tag(:li, link_to(t('home') , root_path))]
    if current_page?('/')
      crumbs
    elsif product
      taxon = product.taxons.where("permalink like 'categories%'").first || product.taxons.where("permalink like 'things-to-do%'").first
      if taxon.nil? && product.taxons.count == 1
        taxon = product.taxons.first
      end
      if taxon
        ancestors = other_ancestors(taxon)
        ancestors.each do |ancestor|
          to_ancestor = ancestor
          if ancestor.permalink == 'destinations'
            to_ancestor = first_child_destination(ancestor)
          end
          crumbs << content_tag(:li, separator + link_to(ancestor.name , seo_url(to_ancestor)))
        end
        if !taxon.permalink.start_with?('destination')
          crumbs << content_tag(:li, separator + content_tag(:span, link_to(taxon.name , seo_url(taxon))))
        end
      end
      crumbs << content_tag(:li, separator + content_tag(:span, product.name))
    elsif taxon
      ancestors = other_ancestors(taxon)
      ancestors.each do |ancestor|
        to_ancestor = ancestor
        if ancestor.permalink == 'destinations'
          to_ancestor = first_child_destination(ancestor)
        end
        crumbs << content_tag(:li, separator + link_to(ancestor.name , seo_url(to_ancestor)))
      end
      crumbs << content_tag(:li, separator + content_tag(:span, link_to(taxon.name , seo_url(taxon))))
    elsif current_page?('/spree/promos/index') || current_page?('/spree/promos/show')
      crumbs <<  content_tag(:li, separator + link_to(t('promotions') , '/spree/promos/index') )

    else
      crumbs
    end
    crumb_list = content_tag(:ul, raw(crumbs.flatten.map{|li| li.mb_chars}.join), :class => 'inline')
    content_tag(:div, crumb_list, :id => 'breadcrumbs')
  end


  def product_view_distributer(product, taxon, home=nil)
    view =  if    product.tour? then 'programs'
            elsif product.program? then 'programs'
            elsif product.accommodation? then 'accommodation'
            elsif product.transfer? then 'rent_transfers'
            elsif product.car? then 'rent_cars'
            elsif product.flight? then 'flights'
            elsif product.point? then 'attractions'
            elsif product.destination? && home then 'destinations'
            else
              'another'
            end
    render_params = {:partial => "spree/shared/#{view}", :locals => {:product => product, :taxon => taxon }}
    render render_params
  end


  def product_show_distributer(product, is_head)
    head = is_head ? 'head_' : ''
    view = if    product.room? then 'room'
           elsif product.tour? then 'programs'
           elsif product.program? then 'programs'
           elsif product.accommodation? then 'accommodation'
           elsif product.flight? then 'flights'    # AQUI NO DEBE ENTRAR
           elsif product.transfer? then 'transfer' # AQUI NO DEBE ENTRAR
           elsif product.rent? then 'car'          # AQUI NO DEBE ENTRAR
           elsif product.point? then 'attractions'
           elsif product.destination? then 'destinations'
           else
              'another'
           end
    render :partial => "spree/products/show_#{head}#{view}", :locals => { :product => product }
  end


  def many_color(taxon=nil)
    if taxon
      taxon_name = taxon.permalink.split('/')
      taxon_name_show = taxon_name[1]
      if taxon_name[0] == 'things-to-do'
        taxon_name_show = 'slider'
      end
      return taxon_name_show
    elsif current_page?('/promos/index') || current_page?("promo/show/")
      #TODO como poner un numeral dentro de   un String para que ve a todos los show de promo
      return 'promotion'
    else
      return 'slider'
    end
  end

  def active_button(taxon, active_taxon)
    if taxon
      if taxon.self_and_descendants.include?(active_taxon)
        return taxon.permalink.split('/')[1]
      end
    end
  end

  def active_promotion(taxon=nil)
    if current_page?('/promos/index') || current_page?('/spree/promos/show')
      return 'promotion'
    end
  end

  def all_destinations(product)
    if product.room?
      product = product.parent_hotel
    end
    taxons = product.taxons.where(:taxonomy_id => Spree::Taxon.find_by_permalink('destinations').taxonomy_id)
    return taxons
  end

  def my_destination(product, with_country=false, home=false)
      if product.room?
        product = product.parent_hotel
      end
      taxon = product.taxons.where(:taxonomy_id => Spree::Taxon.find_by_permalink('destinations').taxonomy_id).first
      if taxon
        name = with_country ? taxon.name + ',' : taxon.name
        name = truncate(name, :length => 25)
        link_to name, nested_taxons_path(taxon.permalink), :class => "product-link"
      end
  end

  def get_category(product)
    taxon = product.taxons.where("permalink like 'categories%'").first
    if taxon
      return taxon.parent.permalink.split('/')[1]
    elsif product.room?
      return 'accommodation'
    else
      return 'destinations'
    end

  end

  def get_attraction_category(product)
    taxon = product.taxons.where("permalink like 'things-to-do%'").first
    if taxon
      return taxon.permalink.split('/')[1]
    end
  end

  def link_to_cart
    return "" if current_page?(cart_path)
    if current_order.nil? or current_order.line_items.empty?
      text = "$0"
    else
      text = "#{order_subtotal(current_order)}"
    end
    text
  end

  def cart_count
    return "" if current_page?(cart_path)
    if current_order.nil? or current_order.line_items.empty?
      text = "0"
    else
      text = "#{current_order.item_count}"
    end
    text
  end

  def order_subtotal(order, options={})
    options.assert_valid_keys(:format_as_currency, :show_vat_text)
    options.reverse_merge! :format_as_currency => true, :show_vat_text => true

    amount =  order.total
    if order.adjustments.eligible.count ==  0
      amount -= order.adjustment_total
    end

    options.delete(:format_as_currency) ? number_to_currency(amount, :precision=>0) : amount
  end

  def get_country(taxon)

    country = taxon.permalink.split('/')[1]
    country_object = Spree::Country.where(:name => country).first

    iso = country_object ? country_object.iso.to_s.downcase : 'cu'

    return iso, country

  end

  def child_destinations(product)
    destinations = []
    taxonomy = Spree::Taxonomy.find_by_name('Destinations')
    taxon = Spree::Taxon.where(:name => product.name, :taxonomy_id => taxonomy.id).first
    if taxon
      Spree::Taxon.where(:parent_id => taxon.id).order(:position).each do |t|
        child_product = Spree::Product.find_by_permalink(t.permalink.gsub('/', '-'))
        if child_product
          destinations << child_product
        end
      end
    end
    return destinations
  end

  def get_vat(product, vat, type='boolean')
    property = Spree::Property.find_by_name(vat)
    product_property = Spree::ProductProperty.where(:product_id => product.id, :property_id => property.id).first
    if product_property
      if type == 'boolean'
        return true if product_property.value.to_i == 1
      elsif type == 'int'
        return product_property.value.to_i
      elsif type == 'str'
        return product_property.value
      end
    end
    return false
  end

  def flash_messages
    [:notice, :error].map do |msg_type|
      if flash[msg_type]
        content_tag :div, flash[msg_type], :class => "flash #{msg_type} slider"
      else
        ''
      end
    end.join("\n").html_safe
  end

  def get_stars(product)
    property = Spree::Property.find_by_name('stars')
    product_property = Spree::ProductProperty.where(:product_id => product.id, :property_id => property.id).first
    if product_property
      return product_property.value.split(' ')[0]
    end
    return false
  end

  def get_property_value(product, property_name)
    property = Spree::Property.find_by_name(property_name)
    product_property = Spree::ProductProperty.where(:product_id => product.id, :property_id => property.id).first
    if product_property
      return product_property.value
    end
    return '?'
  end

  def product_image_index(product)
    if !product.images.empty?
      img = product.images.first
      product.images.each do |i|
        if i.attachment_file_name == product.permalink + '.jpg' ||  i.attachment_file_name == product.permalink + '-1.jpg'
          img = i
          break
        end
      end
      #link_to (image_tag product.images.first.attachment.url(:list)), product
      #image_tag product.images.first.attachment.url(:list)
      image_tag img.attachment.url(:list)
    end
  end

  def complete_name(category)
    names = [category.name]
    pcategory = category.parent
    if !pcategory.parent.nil?
      names << pcategory.name
      pcategory = pcategory.parent
    end
    names = names.reverse
    complete_name = names.join(' - ')
    complete_name
  end

  def pass_context(product, var, context)
    # TODO: poner todos los terminos en ingles para luego traducirlos
    description_for_checkout = ''
    category = product.taxons.where("permalink like 'categories%'").first
    if category.nil? && product.room?
      category = Spree::Taxon.find_by_permalink('categories/accommodation')
    end
    category_name = complete_name(category)
    description_for_checkout += "Categoría: #{category_name}|"

    if ['programs', 'tours'].include?(category.permalink.split('/')[1])
      description_for_checkout += "Fecha: #{(context[:date_program]     || Constant.DEFAULT_DATE_PROGRAM).to_date}|"
      description_for_checkout += "Adultos: #{(context[:adults_program] || Constant::DEFAULT_ADULTS_PROGRAM).to_i}|"
      description_for_checkout += "Niños: #{(context[:children_program] || Constant::DEFAULT_CHILDREN_PROGRAM).to_i}|"

    elsif category.permalink.split('/')[1] == 'accommodation'
      description_for_checkout += "Fecha de entrada: #{(context[:check_in_accommodation]   || Constant.DEFAULT_CHECK_IN_ACCOMMODATION).to_date}|"
      description_for_checkout += "Fecha de salida: #{(context[:check_out_accommodation] || Constant.DEFAULT_CHECK_OUT_ACCOMMODATION).to_date}|"
      description_for_checkout += "Adultos: #{(context[:adults_accommodation]      || Constant::DEFAULT_ADULTS_ACCOMMODATION).to_i}|"
      description_for_checkout += "Niños: #{(context[:children_accommodation]      || Constant::DEFAULT_CHILDREN_ACCOMMODATION).to_i}|"
      description_for_checkout += "Infantes: #{(context[:infants_accommodation]    || Constant::DEFAULT_INFANTS_ACCOMMODATION).to_i}|"
      meal_plan_id = (context[:meal_plan_accommodation] || Constant.DEFAULT_MEAL_PLAN_ACCOMMODATION).to_i
      description_for_checkout += "Plan: #{Spree::OptionValue.find(meal_plan_id).presentation}|"

    elsif category.permalink.split('/')[1] == 'flight'
      description_for_checkout += "Fecha: #{(context[:date_flight]     || Constant.DEFAULT_INIT_DATE_FLIGHT).to_date}|"
      description_for_checkout += "Adultos: #{(context[:adults_flight] || Constant::DEFAULT_ADULTS_FLIGHT).to_i}"
      description_for_checkout += "Niños: #{(context[:children_flight] || Constant::DEFAULT_CHILDREN_FLIGHT).to_i}"

    elsif category.permalink.split('/')[2] == 'transfers'
      description_for_checkout += "Fecha: #{(context[:date_transfer]     || Constant.DEFAULT_INIT_DATE_TRANSFER).to_date}|"
      description_for_checkout += "Adultos: #{(context[:adults_transfer] || Constant::DEFAULT_ADULTS_TRANSFER).to_i}|"
      description_for_checkout += "Niños: #{(context[:children_transfer] || Constant::DEFAULT_CHILDREN_TRANSFER).to_i}|"
      confort_id = (context[:confort_transfer]  || Constant.DEFAULT_CONFORT_TRANSFER).to_i
      description_for_checkout += "Confort: #{Spree::OptionValue.find(confort_id).presentation}|"

    elsif category.permalink.split('/')[2] == 'rent-cars'
      description_for_checkout += "Fecha recogida: #{(context[:date_rent]          || Constant.DEFAULT_INIT_DATE_RENT).to_date}|"
      description_for_checkout += "Fecha entrega #{(context[:date_devolution_rent] || Constant.DEFAULT_END_DATE_RENT).to_date}|"
      transmission_id = (context[:transmission_rent] || Constant.DEFAULT_TRANSMISSION_RENT).to_i
      description_for_checkout += "Trasmisión: #{Spree::OptionValue.find(transmission_id).presentation}|"
    end
    description_for_checkout
  end

  def get_properties_to_filter(taxon)
    properties_to_filter = []
    dict_properties = {
        'programs' => ['Programs Feature', 'Programs Include'],
        'tours' => ['Tours Feature', 'Tours Include'],
        'accommodation' => ['Hotel Feature', 'General Services'],
        'flights' => ['Flight Feature'],
        'transfers' => ['Transfer Feature'],
        'rent-cars' => ['Rent Feature']
    }
    # TODO: incluir aqui un filtro para quitar las properties que no tengan true en el campo to_filter, este campo
    # hay que crearlo, asi como crear un position para que se puedan ordenar.
    property_names = dict_properties[taxon.permalink.split('/')[1]] || dict_properties[taxon.permalink.split('/').last]
    if property_names
      property_type_feature = Spree::PropertyType.find_by_name(property_names.first)
      properties_to_filter << property_type_feature.properties.includes(:product_properties, :translations).order(:position)
      if property_names.count > 1
        property_type_include = Spree::PropertyType.find_by_name(property_names.last)
        properties_to_filter << property_type_include.properties.includes(:translations, :product_properties).order(:position)
      end
    end
    properties_to_filter
  end

end
