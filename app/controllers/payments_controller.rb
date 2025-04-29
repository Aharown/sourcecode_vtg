class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create_checkout_session]  # Temporarily skip CSRF token check for testing

  def create_checkout_session
    sold_items = []
    cart_items = []

    session[:cart]&.each do |id, quantity|
      garment = Garment.find_by(id: id)

      if garment.nil? || garment.sold
        sold_items << garment&.name || "Item ##{id}"
      else
        cart_items << {
          price: garment.stripe_price_id,
          quantity: quantity
        }
      end
    end

    if sold_items.any?
      render json: {
        error: "The following items are no longer available: #{sold_items.join(', ')}"
      }, status: :unprocessable_entity
      return
    end

    session = Stripe::Checkout::Session.create(
      ui_mode: 'embedded',
      line_items: cart_items,
      mode: 'payment',
      return_url: "#{thank_you_url}?session_id={CHECKOUT_SESSION_ID}",
    )

    render json: { clientSecret: session.client_secret }
  end

  def session_status
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    render json: { status: session.status, customer_email: session.customer_details.email }
  end

  def thank_you
    if params[:session_id].present?
      session = Stripe::Checkout::Session.retrieve(params[:session_id])
      @customer_email = session.customer_details.email
    end
  end
end
