class RemoveVariantColumnFromSpreePrice < ActiveRecord::Migration[6.0]
  def change
    remove_column :spree_prices, :variant_id, :integer
  end
end
