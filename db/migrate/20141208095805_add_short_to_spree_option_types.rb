class AddShortToSpreeOptionTypes < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_option_types, :short, :string
  end
end
