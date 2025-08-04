class AddCloudinaryPhotosToGarments < ActiveRecord::Migration[7.1]
  def change
    add_column :garments, :cloudinary_photos, :text
  end
end
