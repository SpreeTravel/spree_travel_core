Spree::Taxon.class_eval do |clazz|

  # Add new attrs for query params (search options) in the request.
  self.whitelisted_ransackable_attributes = %w[parent_id]

end