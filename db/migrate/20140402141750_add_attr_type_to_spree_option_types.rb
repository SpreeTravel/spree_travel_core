class AddAttrTypeToSpreeOptionTypes < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_option_types, :attr_type, :string, :default=>'selection'
  end
end
