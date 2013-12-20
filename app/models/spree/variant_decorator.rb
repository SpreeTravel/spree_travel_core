Spree::Variant.class_eval do

  def long_sku
    (self.option_values.order(:position).map(&:name)).join('-')
  end

end
