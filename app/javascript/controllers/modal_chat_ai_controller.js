import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "modal" ] 

  toggle() {
    this.modalTarget.classList.toggle("hidden")
    const isHidden = this.modalTarget.classList.contains("hidden");
    this.modalTarget.setAttribute("aria-hidden", isHidden);
  }
}
