class AddPaxToLineItem < ActiveRecord::Migration[4.2]
  def change
    add_reference :spree_line_items, :pax, foreign_key: {to_table: :spree_paxes}, index: true
  end
end
