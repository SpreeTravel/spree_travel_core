module ActiveRecord
    class Base

        def merge_conditions(*conditions)
            ret = {}
            conditions.each{ |a| ret.merge!(a) if a.is_a?(Hash) }
            ret
        end
    end
end
