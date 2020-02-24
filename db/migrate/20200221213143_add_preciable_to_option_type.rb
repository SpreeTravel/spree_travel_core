class AddPreciableToOptionType < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_option_types, :preciable, :boolean, default: false
  end
end
