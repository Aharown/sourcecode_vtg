module Stripe
  class Webhook
    module Signature
      def self.compute_header(payload, secret, timestamp)
        signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, "#{timestamp}.#{payload}")
        "t=#{timestamp},v1=#{signature}"
      end
    end
  end
end
