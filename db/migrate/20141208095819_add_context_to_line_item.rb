class AddContextToLineItem < ActiveRecord::Migration[4.2]
  def change
    add_reference :spree_line_items, :context, foreign_key: {to_table: :spree_contexts}, index: true
  end
end
