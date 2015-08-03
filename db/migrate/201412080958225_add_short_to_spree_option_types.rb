class AddVariantIdToCombinations < ActiveRecord::Migration
  def change
    add_column :spree_combinations, :variant_id, :integer
  end
end

