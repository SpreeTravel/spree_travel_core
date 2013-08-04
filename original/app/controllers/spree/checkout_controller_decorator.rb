Spree::CheckoutController.class_eval do

  def common_part
    fire_event('spree.checkout.update')

    if @order.next
      state_callback(:after)
    else
      #flash[:error] = t('payment_processing_failed')
      respond_with(@order, :location => checkout_state_path(@order.state))
      return
    end

    if @order.state == "complete" || @order.completed?
      flash.notice = t('order_processed_successfully')
      flash[:commerce_tracking] = "nothing special"
      respond_with(@order, :location => completion_route)
    else
      respond_with(@order, :location => checkout_state_path(@order.state))
    end
  end

  def update
    session[:paxs] = params[:paxs]
    case @order.state
      when 'pax'
        if params[:order][:pax_contacts_attributes].present?
          complicated = params[:order][:pax_contacts_attributes]
          contacts = complicated.keys.map { |key| Spree::PaxContact.new(complicated[key])}
          @order.pax_contacts = contacts
          common_part
        end
      else
        puts object_params
        if @order.update_attributes(object_params)
          common_part
        else
          respond_with(@order) { |format| format.html { render :edit } }
        end
    end
  end

  def object_params
    # For payment step, filter order parameters to produce the expected nested attributes for a single payment and its source, discarding attributes for payment methods other than the one selected
    #if @order.payment?
    #  if params[:payment_source].present? && source_params = params.delete(:payment_source)[params[:order][:payments_attributes].first[:payment_method_id].underscore]
    #    params[:order][:payments_attributes].first[:source_attributes] = source_params
    #  end
    #  if (params[:order][:payments_attributes])
    #    params[:order][:payments_attributes].first[:amount] = @order.total
    #  end
    #end
    params[:order]
  end

  #def before_pax
  #  if  @order.pax_contacts.empty?
  #    session[:paxs].to_i.times { @order.pax_contacts.new }
  #  end
  #end

  def before_pax
    if @order.pax_contacts.empty?
      sum = 0
      @order.line_items.each do |li|
        sum += li.pax_for_checkout
      end
      sum.times { @order.pax_contacts.new }
    end
  end


end