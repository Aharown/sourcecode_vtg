class AddNewInToGarments < ActiveRecord::Migration[7.1]
  def change
    add_column :garments, :new_in, :boolean
  end
end
