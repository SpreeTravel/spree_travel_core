Spree::OrderContents.class_eval do

    def add_to_line_item(line_item, variant, quantity, currency=nil, shipment=nil)
      if line_item
        line_item.target_shipment = shipment
        line_item.quantity += quantity.to_i
        line_item.currency = currency unless currency.nil?
      else
        line_item = order.line_items.new(quantity: quantity, variant: variant)
        line_item.target_shipment = shipment
        if currency
          line_item.currency = currency unless currency.nil?
          line_item.price    = variant.price_in(currency).amount
        else
          line_item.price    = variant.price
        end
      end

      line_item.save
      #TODO aqui llega la cantidad de adultos y niños por cada categoría de producto.
      (variant.get_option_value_from_name('adult')[-1].to_i + variant.get_option_value_from_name('child')[-1].to_i).times{ Spree::Pax.create(line_item_id: line_item.id ) }
      order.reload
      line_item
    end

end
