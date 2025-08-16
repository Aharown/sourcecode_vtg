class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create_checkout_session]

  def create_checkout_session
    cart_items = session[:cart].map do |id, quantity|
      garment = Garment.find(id)
      {
        price: garment.stripe_price_id,
        quantity: quantity
      }
    end

    all_countries = ISO3166::Country.codes
    stripe_countries = Stripe::CountrySpec.list.data.map(&:id)
    allowed_countries = all_countries & stripe_countries

    domestic_rates = [
      { shipping_rate: "shr_1RwlLk09wjVeLyNkEFJflxWa" },
      { shipping_rate: "shr_1RwlJz09wjVeLyNkXmnG9Kdp" }
    ]
    international_rate = { shipping_rate: "shr_1RwmNX09wjVeLyNkB9QFStDx" }

    shipping_options = [
      { shipping_rate: "shr_1RwlLk09wjVeLyNkEFJflxWa" },
      { shipping_rate: "shr_1RwlJz09wjVeLyNkXmnG9Kdp" }
    ]
    shipping_options = [international_rate] if params[:country] != "GB"

    checkout_session = Stripe::Checkout::Session.create(
      ui_mode: 'embedded',
      line_items: cart_items,
      mode: 'payment',
      return_url: "#{thank_you_url}?session_id={CHECKOUT_SESSION_ID}",
      shipping_address_collection: {
        allowed_countries: allowed_countries
      },
      shipping_options: shipping_options,
      metadata: {
        garment_ids: cart_items.map.with_index { |item, i| session[:cart].keys[i] }.join(',')
      }
    )

    render json: { clientSecret: checkout_session.client_secret }
  end

  def session_status
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    render json: { status: session.status, customer_email: session.customer_details.email }
  end

  def thank_you
    if params[:session_id].present?
      session[:cart] = {}
      stripe_session = Stripe::Checkout::Session.retrieve(params[:session_id])
      garment_ids = stripe_session.metadata["garment_ids"].split(',')
      Garment.where(id: garment_ids).update_all(sold: true)

      @customer_email = stripe_session.customer_details.email
    end
  end
end
