import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["open", "closed", "menu"]

  static values = {
    open: { type: Boolean, default: false },
  }

  toggle(event) {
    event.preventDefault()
    this.openValue = !this.openValue

    if (this.openValue) {
      this.openTarget.hidden = false
      this.menuTarget.hidden = false
      this.closedTarget.hidden = true
    } else {
      this.closedTarget.hidden = false
      this.openTarget.hidden = true
      this.menuTarget.hidden = true
    }
  }
}
