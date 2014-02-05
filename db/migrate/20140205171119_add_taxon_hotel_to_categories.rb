class AddTaxonHotelToCategories < ActiveRecord::Migration
  def up
    taxonomy = Spree::Taxonomy.where(name: 'Categories').first_or_create
    taxon = Spree::Taxon.where(permalink: 'categories/hotel').first_or_create(taxonomy_id: taxonomy.id)
  end
  
  def down
    Spree::Taxon.where(permalink: 'categories/hotel').delete!
  end
end
