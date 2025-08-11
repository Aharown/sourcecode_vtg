class ChangeCloudinaryPhotosDefaultInGarments < ActiveRecord::Migration[7.1]
  def change
    change_column_default :garments, :cloudinary_photos, from: "{}", to: nil
  end
end
