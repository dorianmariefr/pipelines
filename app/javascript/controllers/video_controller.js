import { Controller } from "@hotwired/stimulus"

const HIDDEN = "hidden"

export default class extends Controller {
  static targets = ["modal"]

  open(event) {
    event.preventDefault()
    this.modalTarget.classList.remove(HIDDEN)
  }

  close(event) {
    event.preventDefault()
    this.modalTarget.classList.add(HIDDEN)
  }
}
