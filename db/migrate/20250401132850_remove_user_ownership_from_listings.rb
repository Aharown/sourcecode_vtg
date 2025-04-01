class RemoveUserOwnershipFromListings < ActiveRecord::Migration[7.1]
  def change
    remove_column :garments, :user_id
  end
end
