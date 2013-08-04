Spree::Taxon.class_eval do
  #default_scope includes(:translations)
  translates :name, :description, :fallbacks_for_empty_translations => true
  attr_accessible :name, :parent_id, :taxonomy_id, :description, :icon, :permalink

  has_attached_file :icon,
                    :styles => { :height => '94x199#', :lessheight => '94x120#' },
                    :default_style => :mini,
                    :url => '/spree/taxons/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/spree/taxons/:id/:style/:basename.:extension',
                    :default_url => 'store/no_imagen_72x72.png'

  # TODO: este metodo hay que eliminarlo, porque no esta optimizado
  # TODO: lo que hay que arreglar son los left y los rights para que self_and_descendants pinche bien
  def recursive_children
    array = []
    array << self
    self.children.each do |c|
      array += c.recursive_children
    end
    array
  end

  def self_and_descendants_ids
    recursive_children.map(&:id)
  end

  def self_and_descendants
    Spree::Taxon.where(:id => self_and_descendants_ids)
  end

  def sorted_children
    self.children.includes(:translations).reorder(:position)
  end

  # Esto me lo mando el migue por correo
  #def set_permalink # No longer add in parent
  #  self.permalink = name.to_url if permalink.blank?
  #end

end

