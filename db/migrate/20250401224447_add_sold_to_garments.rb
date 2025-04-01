class AddSoldToGarments < ActiveRecord::Migration[7.1]
  def change
    add_column :garments, :sold, :boolean
  end
end
