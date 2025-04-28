class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create_checkout_session]  # Temporarily skip CSRF token check for testing

  def create_checkout_session
    cart_items = session[:cart].map do |id, quantity|
      garment = Garment.find(id)
      {
        price: garment.stripe_price_id,
        quantity: quantity
      }
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
