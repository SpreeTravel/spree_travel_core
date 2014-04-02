class CreateSpreePrototypesRateOptionTypes < ActiveRecord::Migration
  def change
    create_table :spree_prototypes_rate_option_types, :index => false do |t|
      t.integer :rate_option_type_id
      t.integer :prototype_id
    end
  end
end
