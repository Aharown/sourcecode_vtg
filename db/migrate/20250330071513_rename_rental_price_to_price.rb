class RenameRentalPriceToPrice < ActiveRecord::Migration[7.1]
  def change
    rename_column :garments, :rental_price, :price 
  end
end
