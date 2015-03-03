module Spree
    OrdersController.class_eval do


    # Adds a new item to the order (creating a new order if none already exists)
    def populate
      # populator = Spree::OrderPopulator.new(current_order(true), current_currency)
      populator = Spree::OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)
      context = Spree::Context.build_from_params(params, :temporal => false)
      #TODO, este save antes se hacia dentro del 'populator.populate' ahora lo saque para que se puedan productos con contextos diferentes
      context.save

      product_hash = params[:products]
      product_key = product_hash.keys.first
      variant_id = product_hash[product_key]
      quantity = params[:quantity]

      #TODO hay que poner algo aqui para asegurar que al carrito solo valla un solo producto, al menos para hoteles

      # if populator.populate(params.slice(:products, :variants, :quantity))
      if populator.populate(variant_id, quantity, context)
        context.line_item = current_order.line_items.last

        variant = false
        params[:products].each do |product_id, variant_id|
            variant = Spree::Variant.find variant_id
        end

        calculator_class = variant.product.calculator.name.constantize

        product = variant.product
        price = product.calculate_price(context, :temporal => false).sort

        line_item = current_order.line_items.last
        line_item.price = price.first.to_i

        line_item.save
        # TODO es probable que esto sea "la meerrrr" en frances, hay que discutirlo y revisarlo
        context.save


        #TODO cuando se añade un al carrito un producto igual con un contexto diferente se debe añadir como otro line item.....

        current_order.ensure_updated_shipments
        # TODO, esto es un cable extremo, no se si esto deba ser así aqui, tengo dudas con relación al "0"
        # TODO esto es para el caso en que se permita solo un producto en el carrito.
        current_order.contents.update_cart(:line_items_attributes=>{"0"=>{"quantity"=>params[:quantity], "id"=>current_order.line_items.last.id}})

        # fire_event('spree.cart.add')
        # fire_event('spree.order.contents_changed')

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
