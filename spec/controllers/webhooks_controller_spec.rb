require 'rails_helper'
require 'openssl'
require 'active_support/log_subscriber/test_helper'

RSpec.describe WebhooksController, type: :controller do
  include StripeSignatureHelper
  include ActiveSupport::LogSubscriber::TestHelper
  setup


  describe 'POST #stripe' do
    let(:webhook_secret) { 'whsec_test_secret' }
    let(:timestamp) { Time.now.to_i }

    before do
      stub_const('ENV', ENV.to_hash.merge('STRIPE_WEBHOOK_SECRET' => webhook_secret))
      initialize_logger
    end

    context 'with a valid signature' do
      let!(:garment) do
        Garment.create!(
          title: 'Test Garment',
          price: 10,
          stripe_price_id: 'price_123',
          sold: false,
          category: Category.create!(name: 'Tops')
        )
      end

      let(:garment_id) { garment.id }

      let(:stripe_event_payload) do
        {
          id: 'evt_test',
          type: 'checkout.session.completed',
          data: {
            object: {
              metadata: { garment_ids: garment.id.to_s },
              payment_status: 'paid'
            }
          }
        }.to_json
      end

      let(:signature_header) do
        generate_stripe_signature_header(
          payload: stripe_event_payload,
          secret: webhook_secret,
          timestamp: timestamp
        )
      end

      before do
        allow(Stripe::Webhook).to receive(:construct_event).and_return(
          Stripe::Event.construct_from(
            id: 'evt_test',
            type: 'checkout.session.completed',
            data: {
              object: Stripe::Checkout::Session.construct_from(
                metadata: { garment_ids: garment.id.to_s },
                payment_status: 'paid'
              )
            }
          )
        )
        request.headers['Stripe-Signature'] = signature_header
      end

      it 'marks the garment as sold' do
        request.headers['CONTENT_TYPE'] = 'application/json'
        request.headers['HTTP_STRIPE_SIGNATURE'] = signature_header

        post :stripe, body: stripe_event_payload

        garment.reload
        expect(garment.sold).to be true
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Success')
      end

      it 'does not update a garment that is already sold' do
        garment.update!(sold: true)

        post :stripe, body: stripe_event_payload

        garment.reload
        expect(garment.sold).to be true
        expect(response).to have_http_status(:ok)
      end

      it 'logs a warning if garment is not found' do
        missing_garment_payload = {
          id: 'evt_test',
          type: 'checkout.session.completed',
          data: {
            object: {
              metadata: { garment_ids: '999999' },
              payment_status: 'paid'
            }
          }
        }.to_json

        missing_signature = generate_stripe_signature_header(
          payload: missing_garment_payload,
          secret: webhook_secret,
          timestamp: timestamp
        )

        allow(Stripe::Webhook).to receive(:construct_event).and_return(
          Stripe::Event.construct_from(
            id: 'evt_test',
            type: 'checkout.session.completed',
            data: {
              object: Stripe::Checkout::Session.construct_from(
                metadata: { garment_ids: '999999' },
                payment_status: 'paid'
              )
            }
          )
        )

        request.headers['Stripe-Signature'] = missing_signature

        post :stripe, body: missing_garment_payload

        expect(response).to have_http_status(:ok)

        warn_logs = @logger.logged(:warn)
        expect(warn_logs.any? { |line| line.include?('Garment not found') }).to be true
      end
    end

    context 'with an invalid signature' do
      it 'returns a 400 error' do
        request.headers['Stripe-Signature'] = 'invalid_signature'
        post :stripe, body: {}.to_json

        expect(response.status).to eq(400)
        expect(response.body).to include('Invalid signature')
      end
    end

    def initialize_logger
      @logger = ActiveSupport::LogSubscriber::TestHelper::MockLogger.new
      Rails.logger = @logger
    end

  end
end
