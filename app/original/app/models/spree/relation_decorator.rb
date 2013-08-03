Spree::Relation.class_eval do
  attr_accessible :relatable, :related_to, :relation_type
  attr_accessible :related_to_id, :related_to_type, :relation_type_id, :discount_amount

end
