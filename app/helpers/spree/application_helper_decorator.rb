module ApplicationHelper

  def rate_url(product)
    rate_class = product.rate_class.to_s.underscore.pluralize
    rate_class = rate_class[6..-1] if rate_class.starts_with?('spree/')
    "/admin/products/#{product.permalink}/#{rate_class}"
  rescue
    '#'
  end
end
