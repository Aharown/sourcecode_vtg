class AddSizeToGarments < ActiveRecord::Migration[7.1]
  def change
    add_column :garments, :size, :string
  end
end
