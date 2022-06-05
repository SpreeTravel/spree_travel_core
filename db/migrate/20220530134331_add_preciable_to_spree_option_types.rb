class AddPreciableToSpreeOptionTypes < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_option_types, :preciable, :boolean, default: false
  end
end
