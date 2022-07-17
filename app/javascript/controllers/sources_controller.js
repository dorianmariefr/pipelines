import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["add", "template"]

  add(event) {
    event.preventDefault()

    let content = this.templateTarget.innerHTML
    content = content.replace(/TEMPLATE_RECORD/g, new Date().valueOf())

    this.addTarget.insertAdjacentHTML("beforebegin", content)
  }

  remove(event) {
    event.preventDefault()

    let item = event.target.closest(".source-js")
    item.querySelector("input[name*='_destroy']").value = 1
    item.style.display = "none"
  }
}
