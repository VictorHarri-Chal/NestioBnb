import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["thumbnail"]
  static values = { parentId: String }
  
  connect() {
    // Listen for slide changes from the parent carousel
    document.addEventListener('carousel:slide-changed', this.handleSlideChanged.bind(this))
  }
  
  disconnect() {
    document.removeEventListener('carousel:slide-changed', this.handleSlideChanged.bind(this))
  }
  
  selectThumbnail(event) {
    const index = parseInt(event.currentTarget.dataset.index)
    
    // Find the parent carousel controller and call goToSlide
    const carousel = document.getElementById(this.parentIdValue)
    if (carousel) {
      const controller = this.application.getControllerForElementAndIdentifier(carousel, 'carousel')
      if (controller) {
        controller.goToSlide(index)
      }
    }
  }
  
  handleSlideChanged(event) {
    // Only respond if the event is from our parent carousel
    const carouselElement = event.target
    if (carouselElement.id !== this.parentIdValue) return
    
    const index = event.detail.index
    
    // Update thumbnails
    this.thumbnailTargets.forEach((thumbnail, i) => {
      if (i === index) {
        thumbnail.classList.add('border-indigo-500')
        thumbnail.classList.remove('border-transparent')
      } else {
        thumbnail.classList.remove('border-indigo-500')
        thumbnail.classList.add('border-transparent')
      }
    })
  }
} 