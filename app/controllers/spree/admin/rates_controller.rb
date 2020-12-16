module Spree
  module Admin
    class RatesController < ResourceController

      before_action :load_product

      def load_product
        @product = Spree::Product.includes(:rates, :option_types, product_type: :rate_option_types)
                                 .find_by(slug: params[:product_id])
      end

      def index
        @product_type_name          = @product.product_type.name
        @product_option_types       = @product.option_types
        @product_rate_option_types  = @product.rate_option_types
        @product_rates              = @product.rates
                                              .includes(variant: [:option_value_variants, :option_values])
      end

      def collection_url
        admin_product_rates_path
      end

      def edit_object_url(rate)
        edit_admin_product_rate_path(:product_id => rate.variant.product.slug, :id => rate.id)
      end

      def object_url(rate)
        admin_product_rate_path(:product_id => rate.variant.product.slug, :id => rate.id)
      end

      # TODO: review params[:rate]
      def create
        @rate = Spree::Rate.new(:variant_id => params[:rate][:variant_id])
        params[:product_type] = @product.product_type.name
        @rate.set_persisted_option_values(params)

        if @rate.save
          flash[:success] = flash_message_for(@rate, :successfully_created)
          redirect_to admin_product_rates_path(params[:product_id])
        else
          invoke_callbacks(:create, :fails)
          respond_with(@object) do |format|
            format.html { render action: :new }
            format.js { render layout: false }
          end
        end
      end

      def update
        @rate = Spree::Rate.find(params[:id])
        @rate.variant_id = params[:rate][:variant_id]
        params[:product_type] = @product.product_type.name
        @rate.set_persisted_option_values(params)
        # TODO the rate is not updated we don't know why.
        if @rate.save
          flash[:success] = flash_message_for(@rate, :successfully_updated)
          redirect_to admin_product_rates_path(params[:product_id])
        else
          invoke_callbacks(:update, :fails)
        end
      end

    end
  end
end
