import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.updateStars()
  }

  updateStars() {
    const selectedRating = this.element.querySelector('input[type="radio"]:checked')?.value || 0
    const stars = this.element.querySelectorAll('svg')

    stars.forEach((star, index) => {
      if (index < selectedRating) {
        star.classList.remove('text-gray-300')
        star.classList.add('text-indigo-500')
      } else {
        star.classList.remove('text-indigo-500')
        star.classList.add('text-gray-300')
      }
    })
  }
}
