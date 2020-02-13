module Spree
  module BaseHelper
    def available_countries
      checkout_zone = Spree::Zone.find_by(name: Spree::Config[:checkout_zone])

      countries = if checkout_zone && checkout_zone.kind == 'country'
                    checkout_zone.country_list
                  else
                    Spree::Country.all
                  end

      countries.collect do |country|
        country.name = Spree.t(country.iso, scope: 'country_names', default: country.name)
        country
      end.sort_by { |c| c.name.parameterize }
    end

    def display_price(product_or_variant)
      product_or_variant.
          price_in(current_currency).
          display_price_including_vat_for(current_price_options).
          to_html
    end

    def link_to_tracking(shipment, options = {})
      return unless shipment.tracking && shipment.shipping_method

      if shipment.tracking_url
        link_to(shipment.tracking, shipment.tracking_url, options)
      else
        content_tag(:span, shipment.tracking)
      end
    end

    def logo(image_path = Spree::Config[:logo])
      link_to image_tag(image_path), spree.respond_to?(:root_path) ? spree.root_path : main_app.root_path
    end

    def meta_data
      object = instance_variable_get('@' + controller_name.singularize)
      meta = {}

      if object.is_a? ApplicationRecord
        meta[:keywords] = object.meta_keywords if object[:meta_keywords].present?
        meta[:description] = object.meta_description if object[:meta_description].present?
      end

      if meta[:description].blank? && object.is_a?(Spree::Product)
        meta[:description] = truncate(strip_tags(object.description), length: 160, separator: ' ')
      end

      if meta[:keywords].blank? || meta[:description].blank?
        meta.reverse_merge!(keywords: current_store.meta_keywords,
                            description: current_store.meta_description)
      end
      meta
    end

    def meta_data_tags
      meta_data.map do |name, content|
        tag('meta', name: name, content: content)
      end.join("\n")
    end

    def method_missing(method_name, *args, &block)
      if image_style = image_style_from_method_name(method_name)
        define_image_method(image_style)
        send(method_name, *args)
      else
        super
      end
    end

    def pretty_time(time)
      [I18n.l(time.to_date, format: :long), time.strftime('%l:%M %p')].join(' ')
    end

    def seo_url(taxon)
      spree.nested_taxons_path(taxon.permalink)
    end

    def frontend_available?
      Spree::Core::Engine.frontend_available?
    end

    private

    def create_product_image_tag(image, product, options, style)
      options[:alt] = image.alt.blank? ? product.name : image.alt
      image_tag main_app.url_for(image.url(style)), options
    end

    def define_image_method(style)
      self.class.send :define_method, "#{style}_image" do |product, *options|
        options = options.first || {}
        options[:alt] ||= product.name
        if product.images.empty?
          if !product.is_a?(Spree::Variant) && !product.variant_images.empty?
            create_product_image_tag(product.variant_images.first, product, options, style)
          else
            if product.is_a?(Variant) && !product.product.variant_images.empty?
              create_product_image_tag(product.product.variant_images.first, product, options, style)
            else
              image_tag "noimage/#{style}.png", options
            end
          end
        else
          create_product_image_tag(product.images.first, product, options, style)
        end
      end
    end

    # Returns style of image or nil
    def image_style_from_method_name(method_name)
      if method_name.to_s.match(/_image$/) && style = method_name.to_s.sub(/_image$/, '')
        style if style.in? Spree::Image.styles.with_indifferent_access
      end
    end

    def display_travel_price(variant:)
      product_type_name = variant.product_type.name
      context = Spree::Context.build_from_params(params.merge!(product_type: product_type_name), temporal:true)
      # This function returns a hash with the price, we need to relate the rates with the Spree::Price
      variant.product.calculate_price(context, variant, temporal: true )
    end

    def get_rate_price(rate, adults, children)
      adults = adults.to_i
      children = children.to_i
      adults_hash = {1 => 'simple', 2 => 'double', 3 => 'triple'}
      price = adults * rate.send(adults_hash[adults]).to_f
      price += rate.first_child.to_f if children >= 1
      price += rate.second_child.to_f if children == 2
      price
    end

  end
end


# module Spree
#   module BaseHelperDecorator
#
#     def display_travel_price(variant:)
#       product_type_name = variant.product_type.name
#       context = Spree::Context.build_from_params(params.merge!(product_type: product_type_name), temporal:true)
#       variant.product.calculate_price(context, product_or_variant, temporal: true )
#     end
#
#     def get_rate_price(rate, adults, children)
#       adults = adults.to_i
#       children = children.to_i
#       adults_hash = {1 => 'simple', 2 => 'double', 3 => 'triple'}
#       price = adults * rate.send(adults_hash[adults]).to_f
#       price += rate.first_child.to_f if children >= 1
#       price += rate.second_child.to_f if children == 2
#       price
#     end
#
#   end
# end
#
# Spree::BaseHelper.prepend Spree::BaseHelperDecorator