class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']

    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      render json: { error: 'Invalid payload' }, status: 400 and return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: 'Invalid signature' }, status: 400 and return
    end

    Rails.logger.info("Stripe webhook received: #{event.type}")
    
    case event.type
    when 'checkout.session.completed'
      fulfill_order(event.data.object)
      render json: { message: 'Success' }, status: 200
    else
      Rails.logger.info("Unhandled event type: #{event.type}")
      render json: { message: 'Unhandled event type' }, status: 200
    end
  end

  private

  def fulfill_order(session)
    return unless session.payment_status == 'paid'

    line_items = Stripe::Checkout::Session.list_line_items(session.id)

    line_items.data.each do |item|
      stripe_price_id = item.price.id
      garment = Garment.find_by(stripe_price_id: stripe_price_id)

      unless garment
        Rails.logger.warn("No garment found for price ID #{stripe_price_id}")
        next
      end

      if garment.sold?
        Rails.logger.info("Garment #{garment.id} already sold")
        next
      end

      garment.update(sold: true)
      Rails.logger.info("Garment #{garment.id} marked as sold")
    rescue => e
      Rails.logger.error("Failed to process garment for price ID #{stripe_price_id}: #{e.message}")
    end
  end
end
