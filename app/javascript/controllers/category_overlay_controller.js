import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay"]

  open() {
    console.log("CategoryOverlay#open triggered")
    this.overlayTarget.classList.remove("d-none")
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
