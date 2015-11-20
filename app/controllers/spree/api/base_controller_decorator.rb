Spree::Api::BaseController.class_eval do

  # Allow Cross-Domain for all actions.
  before_filter :set_access_control_headers

  private

  # Prepare header for allow Cross-Domain.
  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token, X-Spree-Token, X-Spree-Order-Token, X-Spree-Order-Id'
    headers['Access-Control-Max-Age'] = "1728000"
  end

end
