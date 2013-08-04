module ActsAsSolr
  class SearchResults
    def suggest
      Hash[@solr_data[:spellcheck]['suggestions']]['collation'] if @solr_data[:spellcheck] && @solr_data[:spellcheck]['suggestions']
    end
  end
end
