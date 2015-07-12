class CreateSpreeCombinations < ActiveRecord::Migration
  def change
    create_table :spree_combinations do |t|
      t.integer :product_id
      t.date :start_date
      t.date :end_date
      t.integer :adults
      t.integer :children
      t.integer :room
      t.integer :plan


      t.timestamps
    end
  end
end
