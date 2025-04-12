# lib/tasks/sync_to_stripe.rake

namespace :stripe do
  desc "Create Stripe products and prices for garments that don't have a price_id"
  task sync_garments: :environment do
    Garment.where(stripe_price_id: [nil, ""]).find_each do |garment|
      puts "Creating Stripe product for: #{garment.title}"

      stripe_product = Stripe::Product.create({
        name: garment.title,
        description: garment.description,
        default_price_data: {
          currency: 'GBP',
          unit_amount: (garment.price * 100).to_i,
        }
      })

      garment.update!(stripe_price_id: stripe_product.default_price)

      puts "✅ Synced #{garment.title} (stripe_price_id: #{garment.stripe_price_id})"
    end

    puts "🎉 All unsynced garments have been added to Stripe."
  end
end
