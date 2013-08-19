Spree::Product.class_eval do


  ###############################################################################
  # Price/Variant Methods
  # TODO: esto debe ir para spree_price_calculator
  ###############################################################################

  # NOTE: este metodo se redefine en las clases herederas
  def variant_for_these_params(params)
    self.master
  end

  # NOTE: este metodo hay que redefinirlo en las clases herederas
  def price_for_these_params(params)
    self.price
  end

  def price_and_variant_for_these_params(params)
    variant = variant_for_these_params(params)
    price = price_for_these_params(params)
    result = {}
    result[:variant] = variant
    result[:price] = price
    result[:customization] = {}
    result
  end


  ###############################################################################
  # Parent/Children Methods
  ###############################################################################

  def parent_relation_name
    Constant::RELATION_IS_CHILD_OF_PARENT
  end

  def children_relation_name
    Constant::RELATION_IS_CHILD_OF_PARENT
  end

  def main_child_relation_name
    Constant::RELATION_IS_MAIN_CHILD_OF_PARENT
  end

  def parent(options = {})
    i_am_related_to_this(parent_relation_name, options)
  end

  def parent=(new_parent, options = {})
    create_relation(parent_relation_name, new_parent, self, options)
  end

  def children(options = {})
    they_are_related_to_me(children_relation_name, options)
  end

  def children=(list_of_children, options = {})
    list_of_children.each do |new_child|
      create_relation(children_relation_name, self, new_child, options)
    end
  end

  def main_child(options = {})
    this_is_related_to_me(main_child_relation_name, options)
  end

  def main_child=(new_main_child, options = {})
    create_relation(main_child_relation_name, self, new_main_child, options)
  end


end
