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

    case event.type
    when 'checkout.session.completed'
      session = event.data.object

      fulfill_order(session)
    end

    render json: { message: 'Success' }, status: 200
  end

  private

  def fulfill_order(session)
    line_items = Stripe::Checkout::Session.list_line_items(session.id)

    line_items.data.each do |item|
      stripe_price_id = item.price.id
      garment = Garment.find_by(stripe_price_id: stripe_price_id)
      garment.update(sold: true) if garment
    end
  end
end
