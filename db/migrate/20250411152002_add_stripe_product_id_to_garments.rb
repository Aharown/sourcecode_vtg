class AddStripeProductIdToGarments < ActiveRecord::Migration[7.1]
  def change
    add_column :garments, :stripe_product_id, :string
  end
end
