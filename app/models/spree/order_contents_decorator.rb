module Spree
  OrderContents.class_eval do

    def add(variant, context, quantity = 1, options = {})
      timestamp = Time.now
      line_item = add_to_line_item(variant, context, quantity, options)
      options[:line_item_created] = true if timestamp <= line_item.created_at
      after_add_or_remove(line_item, options)
    end

    private

    def add_to_line_item(variant, context, quantity, options = {})
      line_item = grab_line_item_by_variant(variant, false, options)

      opts = { currency: order.currency }.merge ActionController::Parameters.new(options).
                                                    permit(Spree::PermittedAttributes.line_item_attributes)

      if true #TODO here must go the Yes-No-Cart Preference
        if line_item
          line_item.destroy
        end
        line_item = order.line_items.new(quantity: quantity, variant: variant, options: opts)
        line_item.context = context
      else
        if line_item
          line_item.quantity += quantity.to_i
          line_item.currency = currency unless currency.nil?
          line_item.context = context
        else
          line_item = order.line_items.new(quantity: quantity, variant: variant, options: opts)
        end
      end
      line_item.target_shipment = options[:shipment] if options.has_key? :shipment
      line_item.save!
      line_item
    end

  end
end
