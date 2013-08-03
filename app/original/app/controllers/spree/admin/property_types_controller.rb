module Spree
    module Admin
        class PropertyTypesController < ResourceController


            def collection_url
                prefix
            end

            def edit_object_url(object, options = {})
                "#{object_url(object)}/edit"
            end

            def object_url(object)
                "#{prefix}/#{object.id}"
            end

            private

            def prefix
                "/spree/admin/property_types"
            end

        end
    end
end
