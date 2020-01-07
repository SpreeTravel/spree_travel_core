class CreateSpreeCalculators < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_travel_calculators do |t|
      t.string :name
      t.integer :product_type_id
    end
  end
end
