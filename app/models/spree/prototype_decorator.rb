module Spree
  Prototype.class_eval do
    has_and_belongs_to_many :rate_option_types,
      :join_table => :spree_prototypes_rate_option_types,
      :class_name => 'Spree::OptionType',
      :foreign_key => 'prototype_id',
      :association_foreign_key => 'rate_option_type_id'
    has_and_belongs_to_many :context_option_types,
      :join_table => :spree_prototypes_context_option_types,
      :class_name => 'Spree::OptionType',
      :foreign_key => 'prototype_id',
      :association_foreign_key => 'context_option_type_id'
    has_and_belongs_to_many :taxons,
      :join_table => :spree_prototypes_taxons,
      :class_name => 'Spree::Taxon',
      :foreign_key => 'prototype_id',
      :association_foreign_key => 'taxon_id'
    belongs_to :product_type, :class_name => 'Spree::ProductType', :foreign_key => 'product_type_id'
  end
end
