class AddLineItemIdToPax < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_paxes, :line_item_id, :integer
  end
end
