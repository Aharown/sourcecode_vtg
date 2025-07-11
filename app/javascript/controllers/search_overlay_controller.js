import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "input"]

  open() {
    console.log("SearchOverlay#open triggered")
    this.overlayTarget.classList.remove("d-none")
    this.inputTarget.focus()
  }

  close(event) {
    if (
      event.type === "click" ||
      (event.type === "keydown" && event.key === "Escape")
    ) {
      this.overlayTarget.classList.add("d-none")
    }
  }
}
