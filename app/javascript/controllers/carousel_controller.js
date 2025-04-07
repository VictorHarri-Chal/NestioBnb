import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slides", "indicator", "thumbnail"]
  static values = {
    autoAdvance: { type: Boolean, default: false }
  }

  connect() {
    if (!this.hasSlidesTarget) return

    this.currentIndex = 0
    this.slideCount = this.slidesTarget.children.length

    // Auto-advance only if explicitly enabled
    if (this.autoAdvanceValue) {
      this.startAutoAdvance()
    }
  }

  disconnect() {
    this.stopAutoAdvance()
  }

  prev() {
    this.goToSlide(this.currentIndex - 1)
  }

  next() {
    this.goToSlide(this.currentIndex + 1)
  }

  goToSlide(index) {
    if (index < 0) index = this.slideCount - 1
    if (index >= this.slideCount) index = 0

    this.currentIndex = index
    this.slidesTarget.style.transform = `translateX(-${this.currentIndex * 100}%)`

    // Update indicators
    this.indicatorTargets.forEach((indicator, i) => {
      if (i === this.currentIndex) {
        indicator.classList.add('bg-white')
        indicator.classList.remove('bg-white/50')
      } else {
        indicator.classList.remove('bg-white')
        indicator.classList.add('bg-white/50')
      }
    })

    // Dispatch event for thumbnails
    const event = new CustomEvent('carousel:slide-changed', {
      detail: { index: this.currentIndex },
      bubbles: true
    })
    this.element.dispatchEvent(event)
  }

  startAutoAdvance() {
    this.stopAutoAdvance()
    this.interval = setInterval(() => this.next(), 5000)
  }

  stopAutoAdvance() {
    if (this.interval) {
      clearInterval(this.interval)
    }
  }

  // Mouse enter/leave handlers
  mouseEnter() {
    this.stopAutoAdvance()
  }

  mouseLeave() {
    if (this.autoAdvanceValue) {
      this.startAutoAdvance()
    }
  }
}
