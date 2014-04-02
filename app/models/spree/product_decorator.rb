Spree::Product.class_eval do

  has_many :product_rate_option_types, :class_name => 'Spree::ProductRateOptionType', :foreign_key => 'product_id'
  has_many :rate_option_types, through: :product_rate_option_types

  before_create :absorb_prototype_features

  # TODO: es posible hace el before_save y actualizar el producto
  def absorb_prototype_features
    prototype = Spree::Prototype.find(prototype_id)
    self.taxons = prototype.taxons
    self.properties = prototype.properties
    self.option_types = prototype.option_types
    self.rate_option_types = prototype.rate_option_types
    self.type = prototype.product_type.name
  end

  # TODO: poner bonito la seleccion de variantes en la creacion de
  # productos, parece que es de Spree

  ############################################################################

  def rates
    rate_class.where(:product_id => self.id)
  end

  def exceptions
    exception_class.where(:product_id => self.id)
  end

  ############################################################################
  # Inheritable Methods
  ############################################################################

  def rate_class
    raise "NOT IMPLEMENTED"
  end

  def context_class
    raise "NOT IMPLEMENTED"
  end

  def exception_class
    raise "NOT IMPLEMENTED"
  end

  def calculator_class
    raise "NOT IMPLEMENTED"
  end

  def generate_variants
    raise "NOT IMPLEMENTED"
  end

  def calculate_price(context)
    raise "NOT IMPLEMENTED"
  end

  ###############################################################################
  # Parent/Children Methods
  ###############################################################################

  def parent_relation_name
    Spree::RELATION_IS_CHILD_OF_PARENT
  end

  def children_relation_name
    Spree::RELATION_IS_CHILD_OF_PARENT
  end

  def main_child_relation_name
    Spree::RELATION_IS_MAIN_CHILD_OF_PARENT
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

  ###############################################################################
  # Option Values for Product
  ###############################################################################

  def adults_options
    self.variants.map{|v| v.option_values.map(&:name).select{|ov| ov.starts_with?('adult')}}.flatten.uniq
  end

  def children_options
    self.variants.map{|v| v.option_values.map(&:name).select{|ov| ov.starts_with?('child')}}.flatten.uniq
  end

  def base_price
    self.price
  end

end
