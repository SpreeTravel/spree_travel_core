module Jaf
  module Product
    module Facet

      def taxon_ids
        taxon_list.map(&:id)
      end

      def is_active
        !deleted_at &&
          available_on &&
          (available_on <= Time.zone.now) &&
          (Spree::Config[:allow_backorders] || count_on_hand > 0)
      end

      # saves product to the Solr index
      def solr_save
        return true if indexing_disabled?
        if evaluate_condition(:if, self)
          if defined? Delayed::Job
            Delayed::Job.enqueue SolrManager.new("solr_save", self, Spree::SolrSearch::Config[:auto_commit])
          else
            debug "solr_save: #{self.class.name} : #{record_id(self)}"
            solr_add to_solr_doc
            solr_commit if Spree::SolrSearch::Config[:auto_commit]
          end
          true
        else
          solr_destroy
        end
      end

      def names_of_taxons
        taxon_names
      end

      def taxon_names
        taxon_list.map(&:name)
      end

      def vehicle_size
        get_option_values('vehicle-size')
      end

      def transmition
        get_option_values('transmition')
      end

      def pax
        get_option_values('pax')
      end

      def duration
        get_option_values('duration')
      end

      def service
        get_option_values('service')
      end

      def level_service
        get_option_values('level-service')
      end

      private

      def store_ids
        if self.respond_to? :stores
          stores.map(&:id)
        else
          []
        end
      end

      def taxon_list
        list = []
        taxons.each do |t|
          list << t
          while t.parent
            t = t.parent
            list << t
          end
        end
        list
      end

      def price_range
        max = 0
        PRODUCT_PRICE_RANGES.each do |range, name|
          return name if range.include?(price)
          max = range.max if range.max > max
        end
        I18n.t(:price_and_above, :price => max)
      end

      def brand_property
        #pp = Spree::ProductProperty.first(:joins => :property,
        #      :conditions => {:product_id => self.id, :spree_properties => {:name => 'brand'}})
        #pp ? pp.value : ''
      end

      def color_option
        get_option_values('color')
      end

      def size_option
        get_option_values('size')
      end

    end
  end
end
