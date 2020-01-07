class AddRateToLineItem < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_line_items, :rate_id, :integer
  end
end
