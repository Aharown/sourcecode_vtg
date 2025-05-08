class ChangeSoldDefaultOnGarments < ActiveRecord::Migration[7.1]
  def change
    change_column_default :garments, :sold, false
    change_column_null :garments, :sold, false, false
  end
end
