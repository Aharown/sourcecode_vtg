# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'open-uri'
Garment.destroy_all
Category.destroy_all
User.destroy_all

puts 'Seeding users...'

users = [
  { username: 'debo', email: 'tahirisoa@hotmail.fr', password: 'password' },
  { username: 'sourcecode_vtg', email: 'cheminko@hotmail.com', password: 'password', profile_photo_url: Rails.root.join('app/assets/images/Aaron user pp.png') },
  { username: 'henri', email: 'henri.clau.bellet@gmail.com', password: 'password' },
]

users.each do |user_data|
  user = User.create!(username: user_data[:username], email: user_data[:email], password: user_data[:password])

  # Attach profile photo if provided
  if user_data[:profile_photo_url].present?
    file = File.open(user_data[:profile_photo_url]) # For local files
    user.profile_photo.attach(io: file, filename: File.basename(user_data[:profile_photo_url]), content_type: 'image/png')
    puts "User #{user_data[:username]} created with a profile photo!"
  else
    puts "User #{user_data[:username]} created without a profile photo."
  end
end


puts "Seeding categories..."

categories = {
  "Men's Leather Jackets" => Category.create!(name: "Men's Leather Jackets"),
  "Dresses" => Category.create!(name: "Dresses"),
  "Sneakers" => Category.create!(name: "Sneakers"),
  "Men's Sweaters" => Category.create!(name: "Men's Sweaters"),
  "Jeans" => Category.create!(name: "Jeans"),
  "Bomber Jackets" => Category.create!(name: "Bomber Jackets"),
  "Sunglasses" => Category.create!(name: "Sunglasses"),
  "Women's Boots" => Category.create!(name: "Women's Boots"),
  "Women's coats" => Category.create!(name: "Women's coats")
}

puts "Categories seeded"

puts "Seeding garments..."

garments = [
  { title: "Avirex Varsity Jacket", description: "Vintage Avirex. An iconic jacket worn by many East Coast Hip Hop pioneers. Very rare.", category_name: "Men's Leather Jackets", brand: "Avirex", price: 200, size: "M", photos: [
    Rails.root.join("app/assets/images/AVIREX 1.webp"),
    Rails.root.join("app/assets/images/AVIREX 2.webp"),
    Rails.root.join("app/assets/images/AVIREX 3.webp"),
    Rails.root.join("app/assets/images/AVIREX 4.webp")
  ]}
]

garments.each do |data|
  # Find the category by name
  category = Category.find_by(name: data[:category_name])

  garment = Garment.create!(
    title: data[:title],
    description: data[:description],
    category: category,
    brand: data[:brand],
    price: data[:price],
    size: data[:size], # Add size here
    user_id: User.pluck(:id).sample
  )

  if data[:photos]
    data[:photos].each do |photo_path|
      garment.photos.attach(
        io: File.open(photo_path),
        filename: File.basename(photo_path),
        content_type: "image/#{File.extname(photo_path).delete('.')}" # Dynamically detect image extension
      )
    end
  end

  puts "#{garment.title} created with #{data[:photos] ? data[:photos].size : 0} photos!"
end

puts "Seeding complete"
