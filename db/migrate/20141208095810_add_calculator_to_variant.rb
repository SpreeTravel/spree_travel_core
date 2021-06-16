class AddCalculatorToVariant < ActiveRecord::Migration[4.2]
  def change
    add_reference :spree_variants, :calculator, foreign_key: {to_table: :spree_travel_calculators}, index: true
  end
end
