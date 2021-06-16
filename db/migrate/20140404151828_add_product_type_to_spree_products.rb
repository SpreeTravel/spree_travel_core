class AddProductTypeToSpreeProducts < ActiveRecord::Migration[4.2]
  def change
    add_reference :spree_products, :product_type, foreign_keys: {to_table: 'spree_product_types'}, index: true
  end
end
