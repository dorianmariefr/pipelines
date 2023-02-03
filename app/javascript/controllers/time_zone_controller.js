import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone

    const option = document.createElement("option")
    option.value = timeZone
    option.text = timeZone
    this.element.add(option, this.element.options[0])

    this.element.value = timeZone
  }
}
