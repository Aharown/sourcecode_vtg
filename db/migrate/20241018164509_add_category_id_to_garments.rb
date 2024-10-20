class AddCategoryIdToGarments < ActiveRecord::Migration[7.1]
  def change
    add_column :garments, :category_id, :integer
  end
end
