import { Controller } from "@hotwired/stimulus"

const SIMPLE = "simple"
const CODE = "code"
const HIDDEN = "hidden"

export default class extends Controller {
  static targets = [
    "kind",
    "template",
    "output",
    "filterTypeTemplate",
    "filterTypeOutput",
    "filterType",
    "simpleFilterType",
    "codeFilterType",
  ]

  connect() {
    this.chooseKind()
  }

  chooseKind() {
    const value = this.kindTargets.find((element) => element.checked)?.value

    const template = this.templateTargets.find(
      (template) => template.dataset.kind === value
    )

    this.outputTarget.innerHTML = template?.innerHTML || ""

    const filterTypeTemplate = this.filterTypeTemplateTargets.find(
      (template) => {
        return template.dataset.kind === value
      }
    )

    this.filterTypeOutputTarget.innerHTML = filterTypeTemplate?.innerHTML || ""

    this.chooseFilterType()
  }

  chooseFilterType() {
    const value = this.filterTypeTargets.find(
      (element) => element.checked
    )?.value

    if (value === SIMPLE) {
      this.simpleFilterTypeTarget.classList.remove(HIDDEN)
      this.codeFilterTypeTarget.classList.add(HIDDEN)
    } else if (value === CODE) {
      this.simpleFilterTypeTarget.classList.add(HIDDEN)
      this.codeFilterTypeTarget.classList.remove(HIDDEN)
    } else {
      this.simpleFilterTypeTarget.classList.add(HIDDEN)
      this.codeFilterTypeTarget.classList.add(HIDDEN)
    }
  }
}
