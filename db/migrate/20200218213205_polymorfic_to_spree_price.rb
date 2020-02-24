class PolymorficToSpreePrice < ActiveRecord::Migration[6.0]
  def change
    add_reference :spree_prices, :preciable, polymorphic: true, index: true
  end
end
