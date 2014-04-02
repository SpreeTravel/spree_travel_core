class CreateSpreeRates < ActiveRecord::Migration
  def change
    create_table :spree_rates do |t|
      t.integer :variant_id

      t.timestamps
    end
  end
end
