class CreateSpreeContextOptionValues < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_context_option_values do |t|
      t.references :context, foreign_key: {to_table: :spree_contexts}, index: true
      t.references :option_value, foreign_key: {to_table: :spree_option_values}, index: true
    end
  end
end
