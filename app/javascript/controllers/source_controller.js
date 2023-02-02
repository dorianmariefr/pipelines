import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["simpleFilterType", "codeFilterType"]

  chooseFilterType(event) {
    if (event.target.value === "simple") {
      this.simpleFilterTypeTarget.classList.remove("hidden")
      this.codeFilterTypeTarget.classList.add("hidden")
    } else if (event.target.value === "code") {
      this.simpleFilterTypeTarget.classList.add("hidden")
      this.codeFilterTypeTarget.classList.remove("hidden")
    } else {
      this.simpleFilterTypeTarget.classList.add("hidden")
      this.codeFilterTypeTarget.classList.add("hidden")
    }
  }
}
