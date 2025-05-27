import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="placeholder"
export default class extends Controller {
  static targets = ["input"]

  hidePlaceholder() {
    this.inputTarget.placeholder = ""
  }

  restorePlaceholder() {
    if (this.inputTarget.value === "") {
      this.inputTarget.placeholder = "> Searching..."
    }
  }
}
