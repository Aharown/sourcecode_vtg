console.log("✅ Using updated cart.js!");

document.addEventListener("turbo:load", () => {
  const checkoutButton = document.getElementById("checkout-button");

  if (checkoutButton) {
    console.log("✅ checkout button found");

    checkoutButton.addEventListener("click", async () => {
      console.log("Checkout button clicked");

      try {
        const response = await fetch("/create-checkout-session", {
          method: "POST",
          headers: { "Content-Type": "application/json" }
        });

        const { clientSecret } = await response.json();

        if (clientSecret) {
          window.location.href = `/checkout?client_secret=${clientSecret}`;
        } else {
          console.error("Client Secret not found in response!");
        }
      } catch (error) {
        console.error("Failed to create checkout session:", error);
      }
    });
  } else {
    console.error("Checkout button not found on the page.");
  }
});
