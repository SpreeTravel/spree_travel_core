Spree::Address.class_eval do |clazz|

  # Remove validation for city and address1 and allow null value.
  _validate_callbacks.each do |callback|
    callback.raw_filter.attributes.delete :city if callback.raw_filter.is_a?(ActiveModel::Validations::PresenceValidator)
    callback.raw_filter.attributes.delete :address1 if callback.raw_filter.is_a?(ActiveModel::Validations::PresenceValidator)
  end

  # Allow null value in zipcode.
  def require_zipcode?
    false
  end

end