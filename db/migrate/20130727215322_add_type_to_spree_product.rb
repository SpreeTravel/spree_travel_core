class AddTypeToSpreeProduct < ActiveRecord::Migration

  def up
    add_column :spree_products, :type, :string, :default => 'Spree::Product'
  end

  def down
    remove_column :spree_products, :type
  end
end
