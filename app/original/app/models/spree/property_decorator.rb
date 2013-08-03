Spree::Property.class_eval do
    belongs_to :property_type
    translates :presentation, :fallbacks_for_empty_translations => true
    attr_accessible :name, :presentation, :property_type_id, :position, :to_filter
end
