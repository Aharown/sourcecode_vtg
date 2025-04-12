# lib/tasks/update_stripe_photos.rake

include Rails.application.routes.url_helpers


Rails.application.routes.default_url_options[:host] = 'http://localhost:3000'

namespace :stripe do
  desc "Update Stripe products with garment photo URLs"
  task update_photos: :environment do
    include Rails.application.routes.url_helpers

    # Host is needed for url_for to work outside of controllers/views
    Rails.application.routes.default_url_options[:host] = "http://localhost:3000"
    Garment.where.not(stripe_price_id: [nil, ""]).find_each do |garment|
      puts "Updating photos for: #{garment.title}"

      # Get the Stripe product ID from the price_id
      price = Stripe::Price.retrieve(garment.stripe_price_id)
      product_id = price.product

      # Collect all photo URLs
      photo_urls = garment.photos.map do |photo|

        url = url_for(photo).split('?').first
        stripped_url = url.gsub(/\?.*/, '') # remove any service-specific query params
        puts "Generated URL: #{stripped_url}"
        stripped_url
      end.compact

      next if photo_urls.empty?

      Stripe::Product.update(
        product_id,
        { images: photo_urls }
      )

      puts "✅ Updated #{garment.title} with #{photo_urls.count} photo(s)"
    end

    puts "🎉 All product images updated on Stripe."
  end
end
