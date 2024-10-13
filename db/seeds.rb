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

puts 'Seeding users...'

users = [
  { username: 'debo', email: 'tahirisoa@hotmail.fr', password: 'password' },
  { username: 'aaron', email: 'cheminko@hotmail.com', password: 'password' },
  { username: 'henri', email: 'henri.clau.bellet@gmail.com', password: 'password' },
]

users.each do |user_data|
  User.create!(username: user_data[:username], email: user_data[:email], password: user_data[:password])
  puts "User #{user_data[:username]} created!"
end

puts "Seeding garments..."

garments = [
  { title: "Avirex Varsity Jacket", description: "Vintage Avirex. An iconic jacket worn by many East Coast Hip Hop pioneers. Very rare. Size M", category: "Men's Leather Jackets", brand: "Avirex", rental_price: 200, photos: [
    Rails.root.join("app/assets/images/AVIREX 1.webp"),
    Rails.root.join("app/assets/images/AVIREX 2.webp"),
    Rails.root.join("app/assets/images/AVIREX 3.webp"),
    Rails.root.join("app/assets/images/AVIREX 4.webp")
  ]},
  { title: "Dior Belted Red Dress", description: "Belted mid-length dress, a hallmark Dior silhouette, embodies modern elegance. Size L", category: "Dresses", brand: "Dior", rental_price: 350, photos: [
    Rails.root.join("app/assets/images/Dior Belted Mid-Length Dress.webp"),
  ]},
  { title: "Nike Air Mags", description: "Back To The Future Nike Air Mags with adaptive fit technology and power laces. One of a kind design. Size 9 EU", category: "Sneakers", brand: "Nike", rental_price: 500, photos: [
    Rails.root.join("app/assets/images/Nike MAG Back to The Future .webp"),
    Rails.root.join("app/assets/images/Nike MAG Back To The Future 2.webp"),
    Rails.root.join("app/assets/images/Nike MAG Back To The Future 3.webp"),
    Rails.root.join("app/assets/images/Nike MAG Back To The Future 4.webp")
  ]},
  { title: "Axel Arigato Cardigan", description: "Cardigan knitted from contrasting wool-blend panels featuring exposed seams. Hand-embroidery finishes this piece. Size L", category: "Men's Sweaters", brand: "Axel Arigato", rental_price: 100, photos: [
    Rails.root.join("app/assets/images/Axel Arigato Cardigan.jpg"),
  ]},
  { title: "Coogi Sweater", description: "The signature COOGI Brights sweater executed in the vibrant colors of Fall - bold and expressive. Unmistakably COOGI. Size S", category: "Men's Sweaters", brand: "COOGI", rental_price: 250, photos: [
    Rails.root.join("app/assets/images/Coogi sweater.webp"),
    Rails.root.join("app/assets/images/COOGI 2.webp"),
    Rails.root.join("app/assets/images/COOGI 3.webp"),
    Rails.root.join("app/assets/images/COOGI 4.webp")
  ]},
  { title: "Evisu Jeans", description: "Mid-rise fit, slim-leg cut, belt loops, five pockets, contrast stitching, designer plaque at back, logo print at back with metallic embroidery. Size W32", category: "Jeans", brand: "Evisu", rental_price: 100, photos: [
    Rails.root.join("app/assets/images/Evisu 1.jpg"),
    Rails.root.join("app/assets/images/Evisu 2.jpg"),
    Rails.root.join("app/assets/images/evisu 3.jpg"),
    Rails.root.join("app/assets/images/Evisu 4.jpg")
  ]},
  { title: "Kapital Bomber Jacket", description: "Padded bomber jacket for man by Kapital in satin khaki with orange detail on the left side. This jacket can be transformed into a soft pillow! Size M", category: "Bomber Jackets", brand: "Kapital", rental_price: 300, photos: [
    Rails.root.join("app/assets/images/KAPITAL 1.jpg"),
    Rails.root.join("app/assets/images/KAPITAL 2.jpg"),
    Rails.root.join("app/assets/images/KAPITAL 3.jpg"),
    Rails.root.join("app/assets/images/KAPITAL 4.jpg")
  ]},
  { title: "Gentle Monster Sunglasses", description: "a simple black frame and a contemporary rectangular silhouette, this model can be paired with any look", category: "Sunglasses", brand: "Gentle Monster", rental_price: 50, photos: [
    Rails.root.join("app/assets/images/GENTLE MONSTER.avif")
  ]},
  { title: "Maison Margiela Tabi Ankle Boots", description: "Tabi 60mm leather ankle boots in black with signature Tabi toe", category: "Women's Boots", brand: "Gentle Monster", rental_price: 50, photos: [
    Rails.root.join("app/assets/images/TABI BOOTS.jpg"),
    Rails.root.join("app/assets/images/TABI BOOTS 2.webp"),
    Rails.root.join("app/assets/images/TABI BOOTS 3.webp"),
    Rails.root.join("app/assets/images/TABI BOOTS 4.webp")
  ]},
  { title: "Burberry Trench Coat", description: "The iconic Burberry trench coat, made in England from shower-resistant cotton gabardine. UK Size 10", category: "Women's coats", brand: "Burberry", rental_price: 200, photos: [
    Rails.root.join("app/assets/images/Burberry 1.webp")
  ]}
]

garments.each do |data|
  garment = Garment.create!(title: data[:title],
  description: data[:description], category: data[:category], brand: data[:brand], rental_price: data[:rental_price], user_id: User.pluck(:id).sample)

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
