module Spree
  OrderContents.class_eval do

    def add(rate, context, quantity = 1, options = {})
      timestamp = Time.now
      line_item = add_to_line_item(rate, context, quantity, options)
      options[:line_item_created] = true if timestamp <= line_item.created_at
      after_add_or_remove(line_item, options)
    end

    private

    def add_to_line_item(rate, context, quantity, options = {})
      line_item = grab_line_item_by_variant(rate, context, false, options)

      opts = { currency: order.currency }.merge ActionController::Parameters.new(options).
                                                    permit(Spree::PermittedAttributes.line_item_attributes)

      if Spree::Config.use_cart
        if line_item
          line_item.quantity += quantity.to_i
          line_item.currency = currency unless currency.nil?
          line_item.context = context
        else
          line_item = order.line_items.new(quantity: quantity, variant: rate.variant, options: opts)
          line_item.price = get_rate_price(rate, context.adult(temporal:false), context.child(temporal:false))
          line_item.cost_price = rate.variant.cost_price if line_item.cost_price.nil?
          line_item.currency = rate.variant.currency if line_item.currency.nil?
        end
      else
        if line_item
          line_item.destroy
        end
        line_item = order.line_items.new(quantity: quantity, variant: rate.variant, options: opts)
        line_item.context = context
        line_item.price = get_rate_price(rate, context.adult(temporal:false), context.child(temporal:false))
        line_item.cost_price = rate.variant.cost_price if line_item.cost_price.nil?
        line_item.currency = rate.variant.currency if line_item.currency.nil?
      end
      line_item.target_shipment = options[:shipment] if options.has_key? :shipment
      line_item.save!
      line_item
    end

    private

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
