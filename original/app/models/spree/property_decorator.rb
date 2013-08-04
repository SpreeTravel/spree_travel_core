Spree::Property.class_eval do
    translates :presentation, :fallbacks_for_empty_translations => true
    attr_accessible :name, :presentation, :position, :to_filter
end
