Spree::Product.class_eval do

  def product?
    self.is?(Spree::Product)
  end

  # TODO: hacer un modelo nuevo tipo PropertyType pero para los herederos
  # la idea es que uno en Admin/Configuracion pueda ver el listado de
  # las clases herederas de spree_product y ademas peuda editar una
  # DESCRIPCION y decidir si está HABILITADA o no esta clase
  # el objetivo es que a la hora de crear un producto nuevo, se ponga
  # en un combo el listado de todos los tipos que ese producto puede ser
  def self.list_of_descendants
    %w(Spree::Product SpreeProductCar Spree::ProductRentacar)
  end

  ###############################################################################
  # Price/Variant Methods
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
  # Asking Methods
  ###############################################################################

  def is?(class_name)
    class_name = class_name.to_s unless class_name.class.to_s == 'String'
    options = []
    options << self.class_name(:full)
    options << self.class_name(:normal)
    options << self.class_name(:small)
    options << self.class_name(:path)
    options << self.class_name(:view)
    options.include?(class_name)
  end

  def full_class_name
    self.type
  end

  def class_name(variant = :normal)
    case variant
    when :full
      prefix = ''
      small  = false
    when :normal
      prefix = "Spree::"
      small  = false
    when :small
      prefix = "Spree::Product"
      small  = false
    when :path
      prefix = ''
      small  = true
    when :view
      prefix = 'spree/product'
      small  = true
    end
    temporal = self.type
    temporal = temporal.underscore if small
    temporal = temporal[prefix.length..-1]
    temporal
  end

  ###############################################################################
  # Parent/Children Methods
  ###############################################################################

  # NOTE: este metodo es el que se debe redefinir en los hijos
  # debe devolver un string con el nombre de la relacion
  # se recomienda que la relación sea siempre del hijo al padre
  # por ejemplo "is_room_for_that_hotel"
  def parent_relation_name
    Constant::RELATION_IS_CHILD_OF_PARENT
  end

  # NOTE: lo mismo que con parent_relation_name
  def children_relation_name
    Constant::RELATION_IS_CHILD_OF_PARENT
  end

  # NOTE: lo mismo aqui
  # NOTE: recomendamos que el main_child tenga las dos relaciones
  # la de children y la de main_child
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

  ###############################################################################
  # Relation Methods
  ###############################################################################
  # TODO: ver si estos metodo van aqui o van en spree_enhanced_relations

  def i_am_related_to_those(relation_name, options = {})
    some_is_related_to_some(relation_name, :relatable_id, :related_to, options)
  end

  def i_am_related_to_this(relation_name, options = {})
    relations = i_am_related_to_those(relation_name, options)
    relations.first
  end

  def they_are_related_to_me(relation_name, options = {})
    some_is_related_to_some(relation_name, :related_to_id, :relatable, options)
  end

  def this_is_related_to_me(relation_name, options = {})
    relations = they_are_related_to_me(relation_name, options)
    relations.first
  end

  def some_is_related_to_some(relation_name, from_id_method, to_method, options = {})
    raise [] if relation_name.nil?
    relation_name = normalize_relation_name(relation_name)
    to_id_method = (to_method.to_s + "_id").to_sym
    options[:limit] ||= Constant::MAX_RELATIONS
    relation_type = Spree::RelationType.where(:name => relation_name).first_or_create
    list = Spree::Relation.where(from_id_method => self.id).where(:relation_type_id => relation_type.id).limit(options[:limit]) #.includes([to_method])
    list.map(&to_method)
  end

  def create_relation(relation_name, parent_object, child_object, options = {})
    relation_name = normalize_relation_name(relation_name)
    relation = Spree::Relation.new
    relation_type = Spree::RelationType.where(:name => relation_name).first_or_create
    relation.relation_type = relation_type
    relation.related_to = parent_object
    relation.relatable = child_object
    relation.save
    relation
  end

  private

  def normalize_relation_name(relation_name)
    relation_name = relation_name.gsub('_', '-')
  end

end
