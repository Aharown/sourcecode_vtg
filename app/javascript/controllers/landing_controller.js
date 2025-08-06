import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["line1", "line2"]

  connect() {
    this.lines = [
      { text: "Enter SOURCECODE_VTG.", target: this.line1Target },
      { text: "Decode vintage. Download style.", target: this.line2Target }
    ]
    this.cursor = document.getElementById("cursor")
    this.button = this.element.querySelector(".pill-button")
    this.button.style.display = "none"
    this.currentLine = 0
    this.currentChar = 0
    this.line1Target.textContent = ""
    this.line2Target.textContent = ""
    this.typeNextChar()
  }

  typeNextChar() {
    if (this.currentLine >= this.lines.length) {
      this.button.style.display = "inline-block"
      return
    }

    const { text, target } = this.lines[this.currentLine]

    if (this.currentChar < text.length) {
      target.textContent += text[this.currentChar]
      this.currentChar++
      this.moveCursorAfter(target)
      setTimeout(() => this.typeNextChar(), 40)
    } else {
      this.currentLine++
      this.currentChar = 0
      setTimeout(() => this.typeNextChar(), 500)
    }
  }

  moveCursorAfter(target) {
    target.parentNode.insertBefore(this.cursor, target.nextSibling)
  }
}
