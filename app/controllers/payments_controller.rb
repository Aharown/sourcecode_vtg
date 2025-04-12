class PaymentsController < ApplicationController
  protect_from_forgery with: :null_session  

  def create_checkout_session
    garment = Garment.find(params[:garment_id])
    session = Stripe::Checkout::Session.create(
      ui_mode: 'embedded',
      line_items: [{
        price: garment.stripe_price_id,
        quantity: 1
      }],
      mode: 'payment',
      return_url: "#{thank_you_url}?session_id={CHECKOUT_SESSION_ID}"
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
