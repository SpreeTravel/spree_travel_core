class CreateSpreeProductTypeRateOptionTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_product_type_rate_option_types do |t|
      t.references :rate_option_type,
                   foreign_key: {to_table: :spree_option_types},
                   index: { name: 'index_product_type_rate_opt_type_on_rot_id' }
      t.references :product_type, foreign_keys: {to_table: 'spree_product_types'}, index: true
    end
  end
end
