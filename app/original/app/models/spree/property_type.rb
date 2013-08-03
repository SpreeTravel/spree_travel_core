class Spree::PropertyType < ActiveRecord::Base

    has_many :properties

    def show_type
        for pair in PropertyShow.all
            if self.show == pair[1]
                return pair[0]
            end
        end
        nil
    end
end
