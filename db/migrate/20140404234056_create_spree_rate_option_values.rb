class CreateSpreeRateOptionValues < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_rate_option_values do |t|
      t.references :rate, foreign_key: {to_table: :spree_rates}, index: true
      t.references :option_value, foreign_key: {to_table: :spree_option_values}, index: true
      t.string :value
      t.string :date_value
      t.integer :pax_value
    end
  end
end
