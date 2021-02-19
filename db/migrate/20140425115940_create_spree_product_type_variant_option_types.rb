class CreateSpreeProductTypeVariantOptionTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_product_type_variant_option_types do |t|
      t.references :variant_option_type,
                   foreign_key: {to_table: :spree_option_types},
                   index: { name: 'index_product_type_variant_option_types_on_vot_id'}
      t.references :product_type,
                   foreign_keys: {to_table: :spree_product_types},
                   index: { name: 'index_product_type_variant_option_types_on_pt_id'}
    end
  end
end
