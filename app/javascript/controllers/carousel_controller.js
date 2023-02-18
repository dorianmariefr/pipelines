import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide"]

  static values = {
    index: { type: Number, default: 0 },
  }

  previous(event) {
    event.preventDefault()
    this.indexValue -= 1
  }

  next(event) {
    event.preventDefault()
    this.indexValue += 1
  }

  indexValueChanged(index) {
    this.slideTargets.forEach((slide) => {
      slide.classList.add("hidden")
    })

    this.slideTargets[index % this.slideTargets.length].classList.remove(
      "hidden"
    )
  }
}
