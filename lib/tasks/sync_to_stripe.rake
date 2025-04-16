namespace :stripe do
  desc "Create Stripe products and prices for garments (and sync images)"
  task sync_garments: :environment do
    Garment.find_each do |garment|
      image_url = garment.photos.first.blob.url if garment.photos.attached?

      if garment.stripe_price_id.blank?
        puts "Creating Stripe product for: #{garment.title}"

        stripe_product = Stripe::Product.create({
          name: garment.title,
          description: garment.description,
          images: image_url ? [image_url] : [],
          default_price_data: {
            currency: 'GBP',
            unit_amount: (garment.price * 100).to_i,
          }
        })

        garment.update!(stripe_price_id: stripe_product.default_price)
        puts "✅ Synced #{garment.title} (new product, price_id: #{garment.stripe_price_id})"

      else
        # Just update images for garments already synced
        product = Stripe::Price.retrieve(garment.stripe_price_id).product

        if image_url
          Stripe::Product.update(product, {
            images: [image_url]
          })
          puts "🖼️ Updated image for #{garment.title}"
        else
          puts "⚠️ Skipping image update for #{garment.title} (no image attached)"
        end
      end
    end

    puts "🎉 All garments are now synced with Stripe (including images)"
  end
end
