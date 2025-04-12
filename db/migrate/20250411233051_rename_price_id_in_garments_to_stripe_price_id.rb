class RenamePriceIdInGarmentsToStripePriceId < ActiveRecord::Migration[7.1]
  def change
    rename_column :garments, :price_id, :stripe_price_id
  end
end
