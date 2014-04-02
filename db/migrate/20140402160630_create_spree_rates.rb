class CreateSpreeRates < ActiveRecord::Migration
  def up
    drop_table :spree_rates
    create_table :spree_rates do |t|
      t.integer :variant_id

      t.timestamps
    end
  end

  def down
    drop_table :spree_rates
    create_table :spree_rates do |t|
      t.string :params
      t.integer :product_id
      t.integer :rate_type_id
      t.timestamps
    end
  end
end
