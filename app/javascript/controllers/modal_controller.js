import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "formOverlay"]

  open(event) {
    event.preventDefault()
    this.overlayTarget.classList.remove('hidden')
  }

  openForm(event) {
    event.preventDefault()
    this.formOverlayTarget.classList.remove('hidden')
  }

  close() {
    this.overlayTarget.classList.add('hidden')
  }

  closeForm() {
    this.formOverlayTarget.classList.add('hidden')
  }
}
