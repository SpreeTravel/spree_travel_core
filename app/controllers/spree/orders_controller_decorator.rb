module Spree
    OrdersController.class_eval do


    # Adds a new item to the order (creating a new order if none already exists)
    def populate
      populator = Spree::OrderPopulator.new(current_order(true), current_currency)

      context = Spree::Context.build_from_params(params)

      if populator.populate(params.slice(:products, :variants, :quantity))

        context.line_item = current_order.line_items.last

        variant = false
        params[:products].each do |product_id,variant_id|
            variant = Spree::Variant.find variant_id
        end

        calculator_class = variant.product.calculator.name.constantize
        #TODO aqui hay que asegurarse que solo vaya un solo precio
        price = calculator_class.calculate_price(context, variant).sort

        line_item = current_order.line_items.last
        line_item.price = price.first.to_d

        line_item.save
        context.save

        current_order.ensure_updated_shipments

        fire_event('spree.cart.add')
        fire_event('spree.order.contents_changed')
        respond_with(@order) do |format|
          format.html { redirect_to cart_path }
        end
      else
        flash[:error] = populator.errors.full_messages.join(" ")
        redirect_to :back
      end
    end


  end
end
