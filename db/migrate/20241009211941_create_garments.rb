class CreateGarments < ActiveRecord::Migration[7.1]
  def change
    create_table :garments do |t|
      t.string :title
      t.text :description
      t.string :category
      t.string :brand
      t.decimal :rental_price, precision: 10, scale: 2
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
