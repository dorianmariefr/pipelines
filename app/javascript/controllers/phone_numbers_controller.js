import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["add", "template", "remove"]
  static values = {
    selector: { type: String, default: ".phone-number-js" },
    destroySelector: { type: String, default: "input[name*='_destroy']" },
    minimum: { type: Number, default: 1 },
  }

  add(event) {
    event.preventDefault()

    let content = this.templateTarget.innerHTML
    content = content.replace(/TEMPLATE_RECORD/g, new Date().valueOf())

    this.addTarget.insertAdjacentHTML("beforebegin", content)
  }

  remove(event) {
    event.preventDefault()

    let item = event.target.closest(this.selectorValue)
    item.querySelector(this.destroySelectorValue).value = 1
    item.hidden = true
  }
}
