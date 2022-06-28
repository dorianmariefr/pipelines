import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["summary", "details"]

  show(event) {
    event.preventDefault()

    this.summaryTarget.remove()
    this.detailsTarget.classList.remove("hidden")
  }
}
