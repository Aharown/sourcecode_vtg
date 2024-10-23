class AddPhotosToGarments < ActiveRecord::Migration[7.1]
  def change
    add_column :garments, :photos, :string
  end
end
