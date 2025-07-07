import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  toggle() {
    this.formTarget.classList.toggle("d-none")
    const input = this.formTarget.querySelector("input")
    if (!this.formTarget.classList.contains("d-none") && input) {
      input.focus()
    }
  }
}
