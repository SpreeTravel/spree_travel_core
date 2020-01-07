class CreateSpreeRates < ActiveRecord::Migration[4.2]
  def up
    create_table :spree_rates do |t|
      t.integer :variant_id

      t.timestamps
    end
  end

  def down
    drop_table :spree_rates
  end
end
