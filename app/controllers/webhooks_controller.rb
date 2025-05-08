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

    garment_ids = session.metadata['garment_ids']&.split(',') || []
    garment_ids.each do |id|
    garment = Garment.find_by(id: id)

      if garment.nil?
        Rails.logger.warn("Garment not found for metadata garment_id #{id}")
        next
      end

      if garment.sold?
        Rails.logger.info("Garment #{garment.id} already sold")
        next
      end

      garment.update(sold: true)
      Rails.logger.info("Garment #{garment.id} marked as sold")
      rescue => e
      Rails.logger.error("Failed to process garment #{id}: #{e.message}")
    end
  end
end
