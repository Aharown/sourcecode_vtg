class ChangeRentalPriceInGarments < ActiveRecord::Migration[7.1]
  def change
    change_column :garments, :rental_price, :integer
  end
end
