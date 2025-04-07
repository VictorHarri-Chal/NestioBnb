import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "submit"]

  connect() {
    this.toggleButton()
  }

  reset() {
    this.inputTarget.value = ""
    this.toggleButton()
  }

  toggleButton() {
    this.submitTarget.disabled = !this.inputTarget.value.trim()
  }
}
