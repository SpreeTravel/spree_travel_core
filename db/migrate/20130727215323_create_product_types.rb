class CreateProductTypes < ActiveRecord::Migration

  def up
    create_table :spree_product_types do |t|
      t.string :name
      t.string :presentation
      t.boolean :enabled, :default => true

      t.timestamps
    end

    pt = Spree::ProductType.new
    pt.name = 'Product'
    pt.presentation = 'Product'
    pt.enabled = true
    pt.save
  end

  def down
    drop_table :spree_product_types
  end
end
