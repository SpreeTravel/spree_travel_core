Spree::LineItem.class_eval do

  def pax_for_checkout
    sum = 0
    rent = Spree::Taxon.find_by_permalink('categories/cars-and-transfers/rent-cars')
    transfer = Spree::Taxon.find_by_permalink('categories/cars-and-transfers/transfers')
    flight_types = Spree::Taxon.find_by_permalink('categories/flights').self_and_descendants
    tour_types = Spree::Taxon.find_by_permalink('categories/tours').self_and_descendants

    if self.product.taxons.include?(rent) || self.product.taxons.include?(transfer)
      #rent and transfers se van por aqui.
      sum += 1
    elsif !(self.product.taxons & tour_types).empty? || !(self.product.taxons & flight_types).empty?
      #tour y flight se va por aqui.
      sum += self.product_customizations.first.customized_product_options.where(:customizable_product_option_id => Spree::CustomizableProductOption.find_by_name('adults_price') ).first.value.to_i
      sum += self.product_customizations.first.customized_product_options.where(:customizable_product_option_id => Spree::CustomizableProductOption.find_by_name('children_price') ).first.value.to_i
      #sum += self.product_customizations.first.customized_product_options.first.value.to_i
      #sum += self.product_customizations.first.customized_product_options.third.value.to_i
      #sum += 2
    else
      #accommodation y programs se va por aqui.
      sum += self.variant.adults + self.variant.children + self.variant.infants
    end
    sum
  end

  #def order_adult_count
  #  adults = 0
  #  @order.line_items.each do |li|
  #    li.variant.option_values.each do |ov|
  #      if ov.option_type.name == 'adult'
  #        adults += ov.presentation.to_i
  #      end
  #    end
  #  end
  #  adults
  #end
  #
  #def order_child_count
  #  child = 0
  #  @order.line_items.each do |li|
  #    li.variant.option_values.each do |ov|
  #      if ov.option_type.name == 'children'
  #        child += ov.presentation.to_i
  #      end
  #    end
  #  end
  #  child
  #end
  #
  #def order_infant_count
  #  infant = 0
  #  @order.line_items.each do |li|
  #    li.variant.option_values.each do |ov|
  #      if ov.option_type.name == 'infant'
  #        infant += ov.presentation.to_i
  #      end
  #    end
  #  end
  #  infant
  #end

end







