class AddCalculatorToVariant < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_variants, :calculator_id, :integer
  end
end
