class CreateSpreeRates < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_rates do |t|
      t.references :variant, index: true, foreign_key: {to_table: :spree_variants}

      t.timestamps
    end
  end
end
