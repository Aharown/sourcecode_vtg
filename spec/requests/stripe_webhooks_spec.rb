require 'rails_helper'


RSpec.describe 'Stripe Webhooks', type: :request do
  include StripeSignatureHelper
  let(:secret) { Rails.application.credentials.dig(:stripe, :webhook_secret) }
  let(:timestamp) { Time.now.to_i }
  let(:valid_payload) { file_fixture('stripe_checkout_session_completed.json').read }
  let(:valid_signature) { generate_stripe_signature_header(payload: valid_payload, secret: secret, timestamp: timestamp) } # <-- FIXED HERE

  context 'with a valid signature' do
    it 'returns 200 OK' do
      post '/webhooks/stripe', params: valid_payload, headers: {
        'Stripe-Signature' => valid_signature,
        'Content-Type' => 'application/json'
      }

      expect(response).to have_http_status(:ok)
    end
  end

  context 'with an invalid signature' do
    it 'returns 400 Bad Request' do
      post '/webhooks/stripe', params: valid_payload, headers: {
        'Stripe-Signature' => 'invalid_signature',
        'Content-Type' => 'application/json'
      }

      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'with an invalid payload' do
    it 'returns 400 Bad Request' do
      post '/webhooks/stripe', params: 'not-json', headers: {
        'Stripe-Signature' => valid_signature,
        'Content-Type' => 'application/json'
      }

      expect(response).to have_http_status(:bad_request)
    end
  end
end
