class AddPaxToLineItem < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_line_items, :pax_id, :integer
  end
end
