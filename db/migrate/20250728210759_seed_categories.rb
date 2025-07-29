class SeedCategories < ActiveRecord::Migration[6.1]
  def up
    category_names = [
      "Jackets",
      "Sweatshirts",
      "Tees",
      "Tops",
      "Denim",
      "Bottoms",
      "Accessories"
    ]

    category_names.each do |name|
      Category.find_or_create_by!(name: name)
    end
  end

  def down
    category_names = [
      "Jackets",
      "Sweatshirts",
      "Tees",
      "Tops",
      "Denim",
      "Bottoms",
      "Accessories"
    ]

    Category.where(name: category_names).destroy_all
  end
end
