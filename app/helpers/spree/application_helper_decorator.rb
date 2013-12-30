module ApplicationHelper

  def rates_url(product)
    rate_class = product.rate_class.to_s.underscore.pluralize
    rate_class = rate_class[6..-1] if rate_class.starts_with?('spree/')
    "/admin/products/#{product.permalink}/#{rate_class}"
  rescue
    '#'
  end

  def combinations_url(product)
    combination_class = product.combination_class.to_s.underscore.pluralize
    combination_class = combination_class[6..-1] if combination_class.starts_with?('spree/')
    "/admin/products/#{product.permalink}/#{combination_class}"
  rescue
    '#'
  end
  
      def get_option_values(option_type)
        list = Spree::OptionValue.joins(:option_type)
        list = list.where('spree_option_types.name = ?', option_type).map &:presentation        
      end
end
