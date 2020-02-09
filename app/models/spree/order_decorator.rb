module Spree::OrderDecorator
  def self.prepended(base)
    base.remove_checkout_step :delivery

    states = base.state_machine.states.map &:name
    unless states.include?(:pax)
      base.insert_checkout_step :pax, after: :address
    end

    base.state_machine.before_transition to: :pax, do: :generate_paxes
  end


    def generate_paxes
      self.line_items.each do |line_item|
        if !line_item.context.nil?
          count = line_item.context.adult(:temporal => false).to_i + line_item.context.child(:temporal => false).to_i
          if line_item.paxes.empty?
            count.times { line_item.paxes.new }
          end
        end
      end
    end

    def empty!
      line_items.each do |li|
        li.paxes.destroy_all
      end
      line_items.destroy_all
      adjustments.destroy_all
    end

    def find_line_item_by_variant(variant, rate=nil, context=nil,  options = {})
      line_items.detect { |line_item|
        line_item.variant_id == variant.id &&
          line_item_options_match(line_item, options)
      }
    end

    def update_from_params(params, permitted_params, request_env = {})
      success = false
      @updating_params = params
      run_callbacks :updating_from_params do
        # Set existing card after setting permitted parameters because
        # rails would slice parameters containg ruby objects, apparently
        existing_card_id = @updating_params[:order] ? @updating_params[:order].delete(:existing_card) : nil

        attributes = if @updating_params[:order]
                       @updating_params[:order].permit(permitted_params).delete_if { |_k, v| v.nil? }
                     else
                       {}
                     end

        if existing_card_id.present?
          credit_card = CreditCard.find existing_card_id
          if credit_card.user_id != user_id || credit_card.user_id.blank?
            raise Core::GatewayError.new Spree.t(:invalid_credit_card)
          end

          credit_card.verification_value = params[:cvc_confirm] if params[:cvc_confirm].present?

          attributes[:payments_attributes].first[:source] = credit_card
          attributes[:payments_attributes].first[:payment_method_id] = credit_card.payment_method_id
          attributes[:payments_attributes].first.delete :source_attributes
        end

        if attributes[:payments_attributes]
          attributes[:payments_attributes].first[:request_env] = request_env
        end

        if attributes["line_items_attributes"]
          attributes["line_items_attributes"].each do |key, value|
            temporal =  attributes["line_items_attributes"][key].delete("paxes_attributes")
            #TODO, this is a patch because i don't know why 'update_attributes' in next line
            #TODO, adds new paxes and does not update existing.
            puts temporal.inspect
            self.line_items[key.to_i].paxes.delete_all
            self.line_items[key.to_i].update_attributes("paxes_attributes" => temporal)
            success = true
          end
        else
          success = update(attributes)
        end

        set_shipments_cost if shipments.any?
      end

      @updating_params = nil
      success
    end

end

Spree::Order.prepend Spree::OrderDecorator