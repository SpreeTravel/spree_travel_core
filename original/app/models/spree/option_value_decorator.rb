Spree::OptionValue.class_eval do
   translates :presentation, :fallbacks_for_empty_translations => true
   attr_accessible :name, :presentation, :option_type_id,:position, :image

   acts_as_solr :fields => [{:updated_timestamp => :integer}, {:created_timestamp => :integer}], :facets => [:updated_timestamp, :created_timestamp]

   def updated_timestamp
     self.updated_at.to_time.to_i
   end

   def created_timestamp
     self.created_at.to_time.to_i
   end

   def duration
     created_timestamp..updated_timestamp
   end
end
