document.addEventListener("turbo:load", async () => {

console.log("✅ Using updated checkout.js!");

const stripe = Stripe(window.StripePublishableKey);

initialize();

async function initialize() {
  // Get the garment ID from the query params
  const garmentId = new URLSearchParams(window.location.search).get('garment_id');

  // Fetch the clientSecret from the server
  const fetchClientSecret = async () => {
    const response = await fetch("/create-checkout-session", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ garment_id: garmentId }) // Send the garment_id if needed
    });

    const { clientSecret } = await response.json(); // Get the clientSecret
    return clientSecret;
  };

  // Fetch the clientSecret
  const clientSecret = await fetchClientSecret();

  // Initialize the embedded checkout
  const checkout = await stripe.initEmbeddedCheckout({
    clientSecret: clientSecret, // Use clientSecret for embedded checkout
  });

  // Mount Checkout in the element with id 'checkout'
  checkout.mount('#checkout'); // Attach to the 'checkout' div
}
});
