module ActsAsSolr
  module ParserMethods

    #def merge_conditions(*conditions)
    #  ret = {}
    #  conditions.each{ |a| ret.merge!(a) if a.is_a?(Hash) }
    #  ret
    #end

    def merge_conditions(*conditions)
      segments = []

      conditions.each do |condition|
        unless condition.blank?
          sql = sanitize_sql(condition)
          segments << sql unless sql.blank?
        end
      end

      "(#{segments.join(') AND (')})" unless segments.empty?
    end
  end
end
