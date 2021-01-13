# Requires factories and other useful helpers defined in spree_core.
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/factories'
require 'spree/testing_support/preferences'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/flash'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/order_walkthrough'
require 'spree/testing_support/capybara_ext'
require 'spree/testing_support/capybara_config'
require 'spree/testing_support/image_helpers'
require 'spree/api/testing_support/caching'
require 'spree/api/testing_support/helpers'
require 'spree/api/testing_support/setup'
require 'spree/api/testing_support/v2/base'
require 'spree/api/testing_support/v2/current_order'

require 'spree/core/controller_helpers/strong_parameters'

RSpec.configure do |config|
  config.include Spree::TestingSupport::Preferences
  config.include Spree::TestingSupport::UrlHelpers
  config.include Spree::TestingSupport::ControllerRequests, type: :controller
  config.include Spree::TestingSupport::Flash
  config.include Spree::TestingSupport::ImageHelpers
  config.include Spree::Api::TestingSupport::Helpers, type: :controller
  config.include Spree::Api::TestingSupport::Helpers, type: :request
end
