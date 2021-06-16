class CreateProductTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_product_types do |t|
      t.string :name
      t.string :presentation
      t.boolean :enabled, :default => true

      t.timestamps
    end
  end
end
