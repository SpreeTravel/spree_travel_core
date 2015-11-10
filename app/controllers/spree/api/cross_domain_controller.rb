module Spree
  module Api
    class CrossDomainController < Spree::Api::BaseController
      # Action to allow cross-domain access.
      def preflight_check
        render nothing: true, content_type: 'text/plain'
      end
    end
  end
end