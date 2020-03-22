require 'spree/core/search/spree_travel_base'

module Spree
  module Core
    module ControllerHelpers
      module Search
        def build_searcher(params)
          product_type = params[:product_type]
          if product_type.present?
            ("Spree::Core::Search::SpreeTravel" + product_type.camelcase + "Base").constantize.new(params).tap do |searcher|
              searcher.current_user = try_spree_current_user
              searcher.current_currency = current_currency
            end
          else
            Spree::Config.searcher_class.new(params).tap do |searcher|
              searcher.current_user = try_spree_current_user
              searcher.current_currency = current_currency
            end
          end
        end
      end
    end
  end
end
