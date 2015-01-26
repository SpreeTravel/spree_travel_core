module Spree
    OrdersController.class_eval do


    # Adds a new item to the order (creating a new order if none already exists)
    def populate
      # populator = Spree::OrderPopulator.new(current_order(true), current_currency)
      populator = Spree::OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)
      context = Spree::Context.build_from_params(params, :temporal => false)

      product_hash = params[:products]
      raise Exception.new("THIS IS WEIRD") if product_hash.keys.count != 1
      product_key = product_hash.keys.first
      raise Exception.new("THIS IS REALLY WEIRD") if product_key != params[:product_id]
      variant_id = product_hash[product_key]
      quantity = params[:quantity]

        puts "--------------------------- 1 --------------------------------"
      # if populator.populate(params.slice(:products, :variants, :quantity))
      if populator.populate(variant_id, quantity)
        puts "--------------------------- 2 --------------------------------"
        context.line_item = current_order.line_items.last
        puts "--------------------------- 3 --------------------------------"

        variant = false
        params[:products].each do |product_id, variant_id|
            variant = Spree::Variant.find variant_id
        end
        puts "--------------------------- 4 --------------------------------"

        calculator_class = variant.product.calculator.name.constantize
        #TODO aqui hay que asegurarse que solo vaya un solo precio

        product = variant.product
        price = product.calculate_price(context).sort

        line_item = current_order.line_items.last
        line_item.price = price.first.to_i

        line_item.save
        context.save

        current_order.ensure_updated_shipments

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
