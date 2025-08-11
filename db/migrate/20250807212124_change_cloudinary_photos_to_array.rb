class ChangeCloudinaryPhotosToArray < ActiveRecord::Migration[7.1]
  def change
    change_column :garments, :cloudinary_photos, :text, array: true, default: [], using: "(string_to_array(cloudinary_photos, '\n'))"
  end
end
