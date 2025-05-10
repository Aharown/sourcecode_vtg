# spec/support/stripe_signature_helper.rb
module StripeSignatureHelper
  def generate_stripe_signature_header(payload:, secret:, timestamp:)
    signed_payload = "#{timestamp}.#{payload}"
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, signed_payload)
    "t=#{timestamp},v1=#{signature}"
  end
end 
