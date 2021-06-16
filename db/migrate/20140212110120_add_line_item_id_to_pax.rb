class AddLineItemIdToPax < ActiveRecord::Migration[4.2]
  def change
    add_reference :spree_paxes, :line_item, index: true, foreign_key: {to_table: :spree_line_items}
  end
end
