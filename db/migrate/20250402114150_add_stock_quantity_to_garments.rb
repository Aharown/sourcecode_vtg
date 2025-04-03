class AddStockQuantityToGarments < ActiveRecord::Migration[7.1]
  def change
    add_column :garments, :stock_quantity, :integer, default: 1, null: false
  end
end
