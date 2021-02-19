class CreateSpreeProductTypeContextOptionTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_product_type_context_option_types do |t|
      t.references :context_option_type,
                   foreign_key: {to_table: :spree_option_types},
                   index: { name: 'index_product_type_context_opt_type_on_cot_id' }
      t.references :product_type,
                   foreign_keys: {to_table: 'spree_product_types'},
                   index: { name: 'index_product_type_ctext_option_types_on_pt_id' }
    end
  end
end
