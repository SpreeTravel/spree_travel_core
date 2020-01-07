class AddProductTypeToSpreeProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_products, :product_type_id, :integer
  end
end
