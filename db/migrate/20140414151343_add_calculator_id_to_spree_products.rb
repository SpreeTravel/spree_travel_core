class AddCalculatorIdToSpreeProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_products, :calculator_id, :integer
  end
end
