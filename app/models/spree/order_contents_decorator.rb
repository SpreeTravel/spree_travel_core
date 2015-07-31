module Spree
  OrderContents.class_eval do

    def add(variant, context, quantity = 1, options = {})
      line_item = add_to_line_item(variant, quantity, context, options)
      after_add_or_remove(line_item, options)
    end

    private

    def add_to_line_item(variant, quantity, context, options = {})
      line_item = grab_line_item_by_variant(variant, context, false, options)

      if line_item
        line_item.quantity += quantity.to_i
        line_item.currency = currency unless currency.nil?
      else
        opts = { currency: order.currency }.merge ActionController::Parameters.new(options).
                                                      permit(PermittedAttributes.line_item_attributes)
        line_item = order.line_items.new(quantity: quantity,
                                         variant: variant,
                                         options: opts)
      end
      line_item.target_shipment = options[:shipment] if options.has_key? :shipment
      line_item.save!
      line_item
    end

    def grab_line_item_by_variant(variant, context, raise_error = false, options = {})
      line_item = order.find_line_item_by_variant(variant, context, options)

      if !line_item.present? && raise_error
        raise ActiveRecord::RecordNotFound, "Line item not found for variant #{variant.sku}"
      end

      line_item
    end

  end
end
