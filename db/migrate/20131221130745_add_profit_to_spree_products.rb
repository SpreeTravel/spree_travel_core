class AddProfitToSpreeProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_products, :profit, :float
  end
end
