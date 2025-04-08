class AddPriceIdToGarments < ActiveRecord::Migration[7.1]
  def change
    add_column :garments, :price_id, :string
  end
end
