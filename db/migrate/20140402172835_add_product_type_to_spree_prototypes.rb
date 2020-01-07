class AddProductTypeToSpreePrototypes < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_prototypes, :product_type_id, :integer
  end
end
