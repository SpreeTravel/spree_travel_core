class AddContextToLineItem < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_line_items, :context_id, :integer
  end
end
