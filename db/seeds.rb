# # This file should ensure the existence of records required to run the application in every environment (production,
# # development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# #

# db/seeds.rb
# db/seeds.rb
# db/seeds.rb

Garment.find_or_create_by!(title: "Vintage Yasuke Turtleneck") do |g|
  g.description = "Yasuke inspired woollen turtle neck."
  g.category = "Sweatshirts"
  g.brand = "RP55"
  g.price = 185
  g.size = "XXL"
  g.stock_quantity = 1
  g.sold = false
  g.new_in = true
  g.cloudinary_photos = [
    "https://res.cloudinary.com/dur4bguyf/image/upload/v1756320167/IMG_3350_eu3uea.jpg",
    "https://res.cloudinary.com/dur4bguyf/image/upload/v1756320173/IMG_3351_ghxgow.jpg",
    "https://res.cloudinary.com/dur4bguyf/image/upload/v1756320173/IMG_3351_ghxgow.jpg"
  ].to_json
end

Garment.find_or_create_by!(title: "Vintage AVIREX B-9 Pilot Jacket") do |g|
  g.description = "Vintage Avirex B-9 pilot jacket."
  g.category = "Jackets"
  g.brand = "Avirex"
  g.price = 400
  g.size = "38"
  g.stock_quantity = 1
  g.sold = false
  g.new_in = true
  g.cloudinary_photos = [
    "https://res.cloudinary.com/dur4bguyf/image/upload/v1756320054/IMG_3358_ydemlc.jpg",
    "https://res.cloudinary.com/dur4bguyf/image/upload/v1756320055/IMG_3359_bwj1kb.jpg",
    "https://res.cloudinary.com/dur4bguyf/image/upload/v1756320055/IMG_3360_jga4id.jpg",
    "https://res.cloudinary.com/dur4bguyf/image/upload/v1756320055/IMG_3361_mwjyhr.jpg"
  ].to_json
end

Garment.find_or_create_by!(title: "Vintage Pelle Pelle Rhinestone Varsity Jacket") do |g|
  g.description = "Embroidered 'P' for Pelle Pelle with rhinestone outlining on chest and back."
  g.category = "Jackets"
  g.brand = "Pelle Pelle"
  g.price = 400
  g.size = "M"
  g.stock_quantity = 1
  g.sold = false
  g.new_in = false
  g.cloudinary_photos = [
    "https://res.cloudinary.com/dur4bguyf/image/upload/v1756320111/IMG_3355_bah6e5.jpg",
    "https://res.cloudinary.com/dur4bguyf/image/upload/v1756320111/IMG_3354_zojuhm.jpg",
    "https://res.cloudinary.com/dur4bguyf/image/upload/v1756320116/IMG_3356_jcq1lq.jpg",
    "https://res.cloudinary.com/dur4bguyf/image/upload/v1756320118/IMG_3357_m7uh4n.jpg"
  ].to_json
end
