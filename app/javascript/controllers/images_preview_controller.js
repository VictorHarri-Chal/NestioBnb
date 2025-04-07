import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  preview() {
    this.previewTarget.innerHTML = ''

    Array.from(this.inputTarget.files).forEach((file, index) => {
      const reader = new FileReader()

      reader.onload = (e) => {
        const container = document.createElement('div')
        container.classList.add('relative', 'inline-block', 'mr-2', 'mb-2')

        const img = document.createElement('img')
        img.src = e.target.result
        img.classList.add('w-full', 'h-48', 'object-cover', 'rounded-lg')

        const deleteButton = document.createElement('button')
        deleteButton.innerHTML = '×'
        deleteButton.classList.add('absolute', 'top-1', 'right-1', 'text-black', 'rounded-full', 'w-6', 'h-6', 'flex', 'items-center', 'justify-center', 'cursor-pointer', 'hover:text-red-600')
        deleteButton.setAttribute('data-index', index)
        deleteButton.addEventListener('click', (event) => this.removeImage(event))

        container.appendChild(img)
        container.appendChild(deleteButton)
        this.previewTarget.appendChild(container)
      }

      reader.readAsDataURL(file)
    })
  }

  removeImage(event) {
    const index = parseInt(event.currentTarget.dataset.index)
    const dt = new DataTransfer()
    const input = this.inputTarget
    const files = input.files

    for (let i = 0; i < files.length; i++) {
      if (i !== index) dt.items.add(files[i])
    }

    input.files = dt.files
    this.preview()
  }
}
