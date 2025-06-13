import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["count"]

  connect() {
    window.addEventListener("cart:updated", this.increment.bind(this))
  }

  disconnect() {
    window.removeEventListener("cart:updated", this.increment.bind(this))
  }

  increment(event) {
    const incrementBy = event.detail.increment || 1
    let currentCount = parseInt(this.countTarget.innerText || "0", 10)
    this.countTarget.innerText = currentCount + incrementBy
  }
}
