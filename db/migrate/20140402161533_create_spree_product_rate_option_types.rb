class CreateSpreeProductRateOptionTypes < ActiveRecord::Migration
  def change
    create_table :spree_product_rate_option_types do |t|
      t.integer :product_id
      t.integer :option_type_id
    end
  end
end
