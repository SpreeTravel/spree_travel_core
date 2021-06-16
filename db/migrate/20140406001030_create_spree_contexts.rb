class CreateSpreeContexts < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_contexts do |t|
      t.references :line_item, foreign_key: {to_table: :spree_line_items}, index: true

      t.timestamps
    end
  end
end
