require 'rails_helper'
require 'openssl'

RSpec.describe WebhooksController, type: :controller do
  describe 'POST #stripe' do
    let(:webhook_secret) { 'whsec_test_secret' }
    let(:timestamp) { Time.now.to_i }

    def generate_stripe_signature_header(payload:, secret:, timestamp:)
      signed_payload = "#{timestamp}.#{payload}"
      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, signed_payload)
      "t=#{timestamp},v1=#{signature}"
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
              metadata: { garment_id: garment_id }
            }
          }
        }.to_json
      end

      before do
        # Mocking the Stripe webhook event
        allow(Stripe::Webhook).to receive(:construct_event).and_return(
          Stripe::Event.construct_from(JSON.parse(stripe_event_payload, symbolize_names: true))
        )
      end

      it 'marks the garment as sold' do
        signature_header = generate_stripe_signature_header(
          payload: stripe_event_payload,
          secret: webhook_secret,
          timestamp: timestamp
        )

        request.headers['Stripe-Signature'] = signature_header
        post :stripe, body: stripe_event_payload

        garment.reload
        expect(garment.sold).to be true
      end

      it 'does not update a garment that is already sold' do
        garment.update!(sold: true)

        signature_header = generate_stripe_signature_header(
          payload: stripe_event_payload,
          secret: webhook_secret,
          timestamp: timestamp
        )

        request.headers['Stripe-Signature'] = signature_header
        post :stripe, body: stripe_event_payload

        garment.reload
        expect(garment.sold).to be true
      end

      it 'logs a warning if garment is not found' do
        stripe_event_payload = {
          id: 'evt_test',
          type: 'checkout.session.completed',
          data: {
            object: {
              metadata: { garment_id: 999_999 }
            }
          }
        }.to_json

        signature_header = generate_stripe_signature_header(
          payload: stripe_event_payload,
          secret: webhook_secret,
          timestamp: timestamp
        )

        expect(Rails.logger).to receive(:warn).with(/Garment not found/)

        request.headers['Stripe-Signature'] = signature_header
        post :stripe, body: stripe_event_payload
      end
    end

    context 'with an invalid signature' do
      it 'returns a 400 error' do
        request.headers['Stripe-Signature'] = 'invalid_signature'
        post :stripe, body: {}.to_json

        expect(response.status).to eq(400)
      end
    end
  end
end
