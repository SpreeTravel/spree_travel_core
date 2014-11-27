class CreateSpreeCombinations < ActiveRecord::Migration
  def change
    create_table :spree_combinations do |t|
      t.integer :product_id
      t.date :start_date
      t.date :end_end
      t.integer :adults
      t.integer :children
      t.string :other

      t.timestamps
    end
  end
end
