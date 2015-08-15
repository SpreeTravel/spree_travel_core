module Spree
    OrdersController.class_eval do

      def populate
        order    = current_order(create_order_if_necessary: true)
        variant  = Spree::Variant.find(params[:variant_id])
        context = Spree::Context.build_from_params(params, :temporal => false)
        quantity = params[:quantity].to_i
        options  = params[:options] || {}

        #Only one service at a time
        if quantity.between?(1, 1)
          begin
            order.contents.add(variant, context, quantity, options)
          rescue ActiveRecord::RecordInvalid => e
            error = e.record.errors.full_messages.join(", ")
          end
        else
          error = Spree.t(:please_enter_reasonable_quantity)
        end

        if error
          flash[:error] = error
          redirect_back_or_default(spree.root_path)
        else
          if true #TODO Yes-No-Cart Preference
            @order = current_order
            params.merge!('checkout'=>'')
            self.update
          else
            respond_with(order) do |format|
              format.html { redirect_to cart_path }
            end
          end
        end
      end


  end
end
