class CreateSpreeCalculators < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_travel_calculators do |t|
      t.string :name
      t.references :product_type, foreign_key: {to_table: :spree_product_types}, index: true
    end
  end
end
