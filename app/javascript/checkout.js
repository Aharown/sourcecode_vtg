document.addEventListener("turbo:load", async () => {

console.log("✅ Using updated checkout.js!");

const stripe = Stripe(window.StripePublishableKey);

initialize();

async function initialize() {
  const garmentId = new URLSearchParams(window.location.search).get('garment_id');

  const fetchClientSecret = async () => {
    const response = await fetch("/create-checkout-session", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ garment_id: garmentId })
    });

    const { clientSecret } = await response.json();
    return clientSecret;
  };

  const clientSecret = await fetchClientSecret();

  const checkout = await stripe.initEmbeddedCheckout({
    clientSecret: clientSecret,
  });

  checkout.mount('#checkout');
}
});
