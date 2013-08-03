module Spree
  OrdersController.class_eval do

    include ProductCustomizations
    include ActiveMerchant::Billing::Integrations
    protect_from_forgery :except=>[:worldpay_return]

    # the inbound variant is determined either from products[pid]=vid or variants[master_vid], depending on whether or not the product has_variants, or not
    #
    # Currently, we are assuming the inbound ad_hoc_option_values and customizations apply to the entire inbound product/variant 'group', as more surgery
    # needs to occur in the cart partial for this to be done 'right'
    #
    def populate
      @order = current_order(true)

      if params[:products]
        params[:products].each do |product_id, variant_id|
          quantity = params[:quantity].to_i if !params[:quantity].is_a?(Hash)
          quantity = params[:quantity][variant_id].to_i if params[:quantity].is_a?(Hash)
          if quantity > 0
            variant = Variant.find(variant_id)
            context = params[:contexts][variant_id]
            @order.add_variant(variant, quantity)
            @order.add_context(variant, context)
          end
        end
      end

      if params[:variants]
        params[:variants].each do |variant_id, quantity|
          quantity = quantity.to_i
          if quantity > 0
            variant = Variant.find(variant_id)
            context = params[:contexts][variant_id]
            @order.add_variant(variant, quantity, product_customizations)
            @order.add_context(variant, context)
          end
        end
      end

      fire_event('spree.cart.add')
      fire_event('spree.order.contents_changed')

      session[:url_before_cart] = params[:url_before_cart] || root_path

      redirect_to cart_path
    end

    def update
      @order = current_order
      puts params[:order].inspect
      if @order.update_attributes(params[:order])
        @order.line_items = @order.line_items.select {|li| li.quantity > 0 }
        fire_event('spree.order.contents_changed')
        respond_with(@order) { |format| format.html { redirect_to cart_path } }
      else
        respond_with(@order)
      end
    end

# Sample Response from World Pay
# FILTER is where I removed my own test details.
# {"region"=>"", "authAmountString"=>"US&#36;1.00", "_SP.charEnc"=>"UTF-8", "desc"=>"", "tel"=>"", "address1"=>"Long Road", "countryMatch"=>"Y", "cartId"=>"4", "address2"=>"", "address3"=>"", "lang"=>"en", "callbackPW"=>"", "rawAuthCode"=>"A", "transStatus"=>"Y", "amountString"=>"US&#36;1.00", "authCost"=>"1.00", "currency"=>"USD", "installation"=>"[FILTER]", "amount"=>"1.00", "countryString"=>"Singapore", "displayAddress"=>"[filter]", "transTime"=>"1329827821950", "name"=>"Rocks", "testMode"=>"100", "routeKey"=>"ECMC-SSL", "ipAddress"=>"[FILTER]", "fax"=>"", "rawAuthMessage"=>"cardbe.msg.authorised", "instId"=>"[FILTER]", "AVS"=>"0112", "compName"=>"MERCHANT WP AP INTERNAL Test Account", "authAmount"=>"1.00", "postcode"=>"", "cardType"=>"MasterCard", "cost"=>"1.00", "authCurrency"=>"USD", "country"=>"SG", "charenc"=>"UTF-8", "email"=>"john@example.com", "address"=>"example road", "transId"=>"128681018", "msgType"=>"authResult", "town"=>"sg", "authMode"=>"A"}

    def worldpay_return
      notification = ActiveMerchant::Billing::Integrations::WorldPay::Notification.new(request.raw_post)

      # TODO: insertar los pagos
      order = Order.find_by_number(params[:cartId])

      if notification.acknowledge
        begin
          if notification.complete? || notification.confirmed?
            order.payment_state = "paid"
          end
        rescue
          #order.state = "failed"
          raise
        ensure
          order.save
        end
      end
	  #redirect_to root_path
      #render :text =>"Order state for #{order.id} is #{order.state}"
    end

    def feed
      @title = "Orders"
      @orders = Spree::Order.order("updated_at desc")
      @updated = @orders.first.updated_at unless @orders.empty?

      respond_to do |format|
        format.atom { render :layout => false }
        format.rss { redirect_to feed_path(:format => :atom), :status => :moved_permanently }
      end
    end

    def without_product

    end

    def create_order_without_product

      #TODO: revisar por que la orden queda en estado pagado cuando se da pay_later

      order = Spree::Order.new()
      order.user_id = current_user.id
      order.save

      line_item = Spree::LineItem.new()
      line_item.order_id = order.id
      line_item.variant_id = Spree::Product.find_by_permalink('generic-product').master.id
      line_item.context = params[:description]
      line_item.price = params[:price].to_f
      line_item.save

      order.line_items = [line_item]
      order.item_total = order.line_items.sum(:price)
      order.total = order.item_total
      order.completed_at = Time.now
      order.payment_state = 'balance_due'
      order.email = params[:email]
      order.save

      if params[:pay_now]
        redirect_to "https://secure.worldpay.com/wcc/purchase?instId=104509&amount=#{order.total}&currency=#{params[:currency]}&cartId=#{order.number}"
      else
        order.confirm!
        redirect_to '/account'
      end

    end

  end
end
