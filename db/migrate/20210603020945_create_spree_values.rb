class CreateSpreeValues < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_values do |t|
      t.date :date
      t.integer :pax
      t.references :valuable, polymorphic: true, index: true
      t.timestamps null: false, precision: 6
    end
  end
end
