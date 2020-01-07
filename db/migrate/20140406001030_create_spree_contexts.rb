class CreateSpreeContexts < ActiveRecord::Migration[4.2]
  def up
    create_table :spree_contexts do |t|
      t.integer :line_item_id

      t.timestamps
    end
  end

  def down
    drop_table :spree_contexts
  end
end
