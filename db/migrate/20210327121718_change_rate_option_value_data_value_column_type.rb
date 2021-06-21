class ChangeRateOptionValueDataValueColumnType < ActiveRecord::Migration[6.0]
  def change
    remove_column :spree_rate_option_values, :date_value
    add_column :spree_rate_option_values, :date_value, :date
  end
end
