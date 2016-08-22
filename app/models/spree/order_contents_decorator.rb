module Spree
  OrderContents.class_eval do

    def add(variant, quantity = 1,rate=nil, context=nil, options = {})
      timestamp = Time.now
      line_item = add_to_line_item(variant, quantity, rate, context, options)
      options[:line_item_created] = true if timestamp <= line_item.created_at
      after_add_or_remove(line_item, options)
    end

    # def add(variant, quantity = 1, options = {})
    #   timestamp = Time.now
    #   line_item = add_to_line_item(variant, quantity, options)
    #   options[:line_item_created] = true if timestamp <= line_item.created_at
    #   after_add_or_remove(line_item, options)
    # end

    def update_cart(params)
      if params[:line_items_attributes][:context]
        context  = Spree::Context.build_from_params(params[:line_items_attributes][:context],
                                                    :temporal => false,
                                                    :line_item_id => params[:line_items_attributes][:id])
        context.line_item_id = params[:line_items_attributes][:id]
        context.save
        params[:line_items_attributes][:context] = context
      end
      if order.update_attributes(filter_order_items(params))
          order.line_items = order.line_items.select { |li| li.quantity > 0 }
          # Update totals, then check if the order is eligible for any cart promotions.
          # If we do not update first, then the item total will be wrong and ItemTotal
          # promotion rules would not be triggered.
          persist_totals
          PromotionHandler::Cart.new(order).activate
          order.ensure_updated_shipments
          persist_totals
          true
        else
          false
      end
    end

    private

    def add_to_line_item(variant, quantity, rate=nil, context=nil, options = {})
      line_item = grab_line_item_by_variant(variant, rate, context, false, options)

      opts = { currency: order.currency }.merge ActionController::Parameters.new(options).
                                                    permit(Spree::PermittedAttributes.line_item_attributes)

      if Spree::Config.use_cart
        if line_item
          line_item.quantity += quantity.to_i
          line_item.currency = currency unless currency.nil?
        else
          if variant.product.product_type && variant.product.product_type.name == 'hotel' && context
            # TODO this logic may be moved to travel_hotel gem becuase is particular for tha PT
            context.room_count(options).to_i.times do
              line_item = order.line_items.new(quantity: quantity, variant: variant, rate: rate, options: opts)
              line_item.context = context
            end
          elsif variant.product.product_type && context
            line_item = order.line_items.new(quantity: quantity, variant: variant, rate: rate, options: opts)
            line_item.context = context
          else
            opts = { currency: order.currency }.merge ActionController::Parameters.new(options).
                permit(PermittedAttributes.line_item_attributes)
            line_item = order.line_items.new(quantity: quantity,
                                             variant: variant,
                                             options: opts)
          end
        end
      else
        # TODO take into account rooms count and diferent context per room and have this login into hotel gem
        order.line_items.destroy_all
        if variant.product.product_type && variant.product.hotel? && context
          context.room_count(options).to_i.times do
            line_item = order.line_items.new(quantity: quantity, variant: variant, rate: rate, options: opts)
            line_item.context = context
          end
        elsif variant.product.product_type && context
          line_item = order.line_items.new(quantity: quantity, variant: variant, rate: rate, options: opts)
          line_item.context = context
        else
          line_item = order.line_items.new(quantity: quantity, variant: variant, options: opts)
        end
      end
      line_item.target_shipment = options[:shipment] if options.has_key? :shipment
      line_item.save!
      line_item
    end

    private

    def grab_line_item_by_variant(variant, rate=nil, context=nil, raise_error = false, options = {})
      line_item = order.find_line_item_by_variant(variant, rate, context, options)

      if !line_item.present? && raise_error
        raise ActiveRecord::RecordNotFound, "Line item not found for variant #{variant.sku}"
      end

      line_item
    end




  end
end
