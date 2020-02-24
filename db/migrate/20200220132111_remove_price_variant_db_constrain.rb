class RemovePriceVariantDbConstrain < ActiveRecord::Migration[6.0]
  def change
    change_column_null :spree_prices, :variant_id, true
  end
end
