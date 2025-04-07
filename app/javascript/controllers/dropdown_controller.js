import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    if (this.menuTarget.classList.contains("hidden")) {
      this.menuTarget.classList.remove("hidden")
      // Trigger a reflow to ensure the transition works
      this.menuTarget.offsetHeight
      this.menuTarget.classList.remove("opacity-0", "scale-95")
      this.menuTarget.classList.add("opacity-100", "scale-100")
    } else {
      this.menuTarget.classList.remove("opacity-100", "scale-100")
      this.menuTarget.classList.add("opacity-0", "scale-95")
      // Wait for the transition to finish before hiding
      setTimeout(() => {
        if (this.menuTarget.classList.contains("opacity-0")) {
          this.menuTarget.classList.add("hidden")
        }
      }, 200)
    }
  }

  closeIfClickedOutside(event) {
    if (!this.element.contains(event.target) && !this.menuTarget.classList.contains("hidden")) {
      this.toggle()
    }
  }
}
