class AddRateToLineItem < ActiveRecord::Migration[4.2]
  def change
    add_reference :spree_line_items, :rate, foreign_key: {to_table: :spree_rates}, index: true
  end
end
