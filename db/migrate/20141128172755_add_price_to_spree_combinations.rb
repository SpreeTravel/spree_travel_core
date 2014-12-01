class AddPriceToSpreeCombinations < ActiveRecord::Migration
  def change
    add_column :spree_combinations, :price, :integer
  end
end
