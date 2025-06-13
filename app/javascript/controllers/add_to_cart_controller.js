import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { itemId: Number }
  static targets = ["button", "actions"]

  add(event) {
    event.preventDefault();

    const itemId = this.itemIdValue;

    fetch("/cart_items", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ item_id: itemId })
    })
      .then(response => {
        if (!response.ok) throw new Error("Network error");
        return response.json();
      })
      .then(() => {
        this.buttonTarget.classList.add("hidden");
        this.actionsTarget.classList.remove("hidden");

        // 👉 Dispatch cart update event
        this.dispatch("cart:updated", { detail: { increment: 1 }, prefix: false });
      })
      .catch(error => {
        console.error("Add to cart failed:", error);
      });
  }
}
