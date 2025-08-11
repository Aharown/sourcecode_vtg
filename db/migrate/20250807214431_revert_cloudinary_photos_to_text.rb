class RevertCloudinaryPhotosToText < ActiveRecord::Migration[7.1]
  def change
    change_column :garments, :cloudinary_photos, :text
  end
end
