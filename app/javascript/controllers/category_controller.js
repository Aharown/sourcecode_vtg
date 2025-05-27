import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="category"
export default class extends Controller {
  static targets = ["hiddenInput"]

  select(event) {
    const categoryId = event.currentTarget.dataset.categoryId
    this.hiddenInputTarget.value = categoryId
    this.element.submit()
  }
}
