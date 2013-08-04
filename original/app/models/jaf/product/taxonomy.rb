module Jaf
  module Product
    module Taxonomy
      def type_is?(string, options = {})
        list_of_taxons = self.taxons

        if options[:max_taxons]
          return false if list_of_taxons.length > options[:max_taxons]
        end

        #for taxon in list_of_taxons
        #  current = taxon
        #  while current != nil
        #    current_name = current.name.to_s.singularize.downcase.gsub(' ','-')
        #    param_name = string.singularize.downcase.gsub(' ','-')
        #    return true if current_name == param_name
        #    current = current.parent
        #  end
        #end
        #return false

        for taxon in list_of_taxons
          parts = taxon.permalink.split('/')
          parts = parts.collect{|p| p.singularize.downcase.underscore }
          return true if parts.include?(string.singularize.downcase.underscore)
        end
        return false
      end
    end
  end
end
