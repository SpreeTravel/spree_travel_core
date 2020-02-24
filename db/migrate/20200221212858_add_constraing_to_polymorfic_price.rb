class AddConstraingToPolymorficPrice < ActiveRecord::Migration[6.0]
  def change
    change_column :spree_prices, :preciable_id, :integer, null: true
    change_column :spree_prices, :preciable_type, :string, null: true
  end
end
