Spree::Taxonomy.class_eval do
  #default_scope includes(:translations)
  translates :name, :fallbacks_for_empty_translations => true
  attr_accessible :name
end


