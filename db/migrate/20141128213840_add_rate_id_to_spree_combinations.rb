class AddRateIdToSpreeCombinations < ActiveRecord::Migration

  def change
    add_column :spree_combinations, :rate_id, :integer
  end
end
