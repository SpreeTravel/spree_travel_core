class AddProductTypeToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :product_type, :string
  end
end
