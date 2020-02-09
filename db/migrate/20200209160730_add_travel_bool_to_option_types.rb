class AddTravelBoolToOptionTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_option_types, :travel, :boolean, default: false
  end
end
