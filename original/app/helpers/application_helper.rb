module ApplicationHelper

    def link_with_problem(name, path, options = {})
      name
    end

    def stars(product)
        number = product.product_stars
        number.times.collect {image_tag('star.png')}.join.html_safe
    end

    def truncated_description(product, length = :rand)
        if product.package?
        else
            length = rand(300) + 100 if length == :rand
            truncate(product.description.to_s.gsub(/<[^>]*>/,''), :length => length) if product.description
        end
    end

    def plan_alimenticio(product)
        plan = nil
        if product.hotel?
            if product.main_room
                plan = product.main_room.plan_alimenticio
            else
                plan = product.plan_alimenticio
            end
        end
        value = ''
        value = content_tag('h5', plan.value) if plan
        value.to_s
    end

    def product_map(product)
        variant = 2

        place = product
        if product.destination?
          product_to_map = product.get_product_to_map_from_destination
          place = product_to_map if product_to_map
          product = product_to_map if product_to_map
        elsif product.room?
          place = product.parent_hotel
        end
        points = points_to_hash(product.points_of_interest)

        case variant
        when 0
            full_url = '/assets/staticmap.png'
        when 1
            url = "http://maps.google.com/maps/api/staticmap"
            options = {}
            options[:size] = '340x255'
            options[:maptype] = 'roadmap'
            options[:sensor] = 'false'
            options[:markers] = "#{place.lat},#{place.lng},blue"
            options[:center] = "#{place.lat},#{place.lng}"
            options[:zoom] = 15
            query_string = options.keys.collect {|key| "#{key}=#{options[key]}"}.join('&')
            full_url = "#{url}?#{query_string}"
        when 2
            map = GoogleStaticMapsHelper::Map.new :size => '340x300', :sensor => false, :maptype => 'hybrid'#, :zoom => map_zoom
            marker = GoogleStaticMapsHelper::Marker.new :lng => place.lng, :lat => place.lat, :color => 'red', :size => 'normal'
            map << marker
            if not product.room?
              for hash in points
                marker = GoogleStaticMapsHelper::Marker.new :lng => hash[:point].lng, :lat => hash[:point].lat, :color => '0x'+hash[:color], :label => hash[:label]
                map << marker
              end
            end
            full_url = map.url
        end
        %<<img itemprop="image" src="#{full_url}">>.html_safe
    end

    def points_to_hash(list, start = '@')
        letter = start
        color  = '00AAF0'
        list.collect do |item|
            letter = letter.succ
            #color  = color.succ
            {:point => item, :label => letter, :color => color}
        end
    end

    def point_of_interest(hash)
        point       = hash[:point]
        color       = hash[:color]
        label       = hash[:label]
        background  = "background-color: ##{color}"
        font_weight = "font-weight: normal"
        #style       = %|style="#{background}; #{font_weight};"|
        #label       = "&nbsp;#{label}&nbsp;"
        point_name  = link_to point do "<span itemprop='name'>#{truncate(point.name, :length => 30, :omission => "...")} </span>".html_safe end
        #%<<span #{style}>#{label}</span>&nbsp;#{point_name}>.html_safe
        "#{point_name} (#{label})".html_safe
    end

    def distance_to_point(product, point)
        dist = product.distance_to(point)
        if dist > 1
          res = "%.2f Km" % dist
        else
          dist = dist * 1000
          res = "%.0f m" % dist
        end
        res
    end

    def related_products(product)
        type = :hr
        if product.package?
             list  = []
            (product.package_members).each do |object|
                case type
                    when :li
                        list << %<<li>#{object.name}</li>\n>
                    when :td
                        image = link_to small_image(object), object
                        list << %<<td>#{image}</td>\n>
                    when :hr
                        name = object.name
                        desc = truncated_description(object, 150)
                        price = %<<span class="selling">#{number_to_currency object.price, :precision => 0 }</span>>
                        list << %<<b>#{name}</b>: #{desc} (#{price})>
                end
            end
            case type
                when :li
                    final = %<<ul>#{list}</ul>\n>
                when :td
                    final = %<<table><tr>#{list}</tr></table>>
                when :hr
                    final = list.join('<hr>')
            end
            raw final
        end
    end

    def remove_html(string)
        string.gsub(/<[^>]*>/, ' ').strip
    end

    def product_image2(product)
        if product.package?
            list = product.package_members
            related = if list.length > 0 then list[0] else product end
            link_to small_image(related), product
        else
            link_to small_image(product), product
        end
    end

    def product_link(type, css, prefix = 'categories')
        permalink = @product.similar_link(type, prefix)
        taxon     = Spree::Taxon.find_by_permalink(permalink)
        amount    = if taxon then taxon.products.count else 0 end
        where     = "/t/" + permalink
        link      = link_to(@product.similar(type), where)
        string    = %|<tr class="#{css}">\n|
        string   += %|<td><strong> #{link} </strong> (#{amount})</td>\n|
        string   += %|</tr>\n|
        string.html_safe
    end

    

end

