# frozen_string_literal: true

module Spree
  module Admin
    class RatesController < ResourceController
      before_action :load_product

      def load_product
        @product = Spree::Product.find_by(slug: params[:product_id])
      end

      def index
        @product_type_name          = @product.product_type.name
        @product_option_types       = @product.option_types
        @product_rate_option_types  = @product.rate_option_types
        @product_rates              = @product.rates
                                              .includes(:rate_option_values, variant: [option_values: :option_type])
      end

      def create
        @rate = Spree::Rate.new(variant_id: params[:rate][:variant_id])
        params[:product_type] = @product.product_type.name

        if save_rate
          flash[:success] = flash_message_for(@rate, :successfully_created)
          redirect_to admin_product_rates_path(params[:product_id])
        else
          flash[:error] = 'There was a problem creating the rate'
          respond_with(@rate) do |format|
            format.html { render action: :new }
            format.js { render layout: false }
          end
        end
      end

      def update
        @rate = Spree::Rate.find(params[:id])
        params[:product_type] = @product.product_type.name

        if save_rate
          flash[:success] = flash_message_for(@rate, :successfully_updated)
          redirect_to admin_product_rates_path(params[:product_id])
        else
          invoke_callbacks(:update, :fails)
        end
      end

      private

      def save_rate
        ApplicationRecord.transaction do
          @rate.persist_option_values(params_sanitize)
          @rate.save!
        end
      rescue StandardError
        false
      end

      def params_sanitize
        Spree::ParamsSanitize.new(klass: 'rate', params: params).call
      end
    end
  end
end
