import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["kind", "template", "output"]

  connect() {
    this.chooseKind()
  }

  chooseKind() {
    const value = this.kindTargets.find((element) => element.checked)?.value

    const template = this.templateTargets.find(
      (template) => template.dataset.kind === value
    )

    this.outputTarget.innerHTML = template?.innerHTML || ""
  }
}
