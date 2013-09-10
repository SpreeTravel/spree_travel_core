Spree::Product.class_eval do

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


end
