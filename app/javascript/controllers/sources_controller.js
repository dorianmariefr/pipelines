import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["add", "template", "remove"]
  static values = {
    selector: { type: String, default: ".source-js" },
    destroySelector: { type: String, default: "input[name*='_destroy']" },
    count: { type: Number, default: 0 },
    minimum: { type: Number, default: 1 },
  }

  add(event) {
    event.preventDefault()

    let content = this.templateTarget.innerHTML
    content = content.replace(/TEMPLATE_RECORD/g, new Date().valueOf())

    this.addTarget.insertAdjacentHTML("beforebegin", content)

    this.updateCount()
  }

  remove(event) {
    event.preventDefault()

    let item = event.target.closest(this.selectorValue)
    item.querySelector(this.destroySelectorValue).value = 1
    item.hidden = true

    this.updateCount()
  }

  updateCount() {
    this.countValue = [
      ...this.element.querySelectorAll(this.selectorValue),
    ].filter((element) => !element.hidden).length
  }

  countValueChanged(count) {
    this.removeTargets.forEach((element) => {
      element.hidden = count <= this.minimumValue
    })
  }
}
