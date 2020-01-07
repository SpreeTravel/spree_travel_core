class CreateSpreeRateOptionValues < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_rate_option_values do |t|
      t.integer :rate_id
      t.integer :option_value_id
      t.string :value
    end
  end
end
