Spree::Api::ApiHelpers.class_eval do |clazz|

  # Add new attributes into responses.
  clazz::taxon_attributes << :icon_file_name
  clazz::product_attributes << :images

end