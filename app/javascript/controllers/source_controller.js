import { Controller } from "@hotwired/stimulus"
import i18n from "../i18n"
import each from "lodash/each"

const t = i18n.scope("source")

export default class extends Controller {
  static targets = ["parameters", "kind"]

  static values = {
    kinds: Object,
    parameters: Object,
  }

  connect() {
    this.update()
  }

  choose() {
    this.update()
  }

  update() {
    const firstKind = this.kindTarget.value.split("/")[0]
    const secondKind = this.kindTarget.value.split("/")[1]
    const kind = this.kindsValue[firstKind][secondKind]

    this.parametersTarget.innerText = ""

    if (kind.parameters) {
      each(kind.parameters, (parameter, key) => {
        const index = Object.keys(kind.parameters).indexOf(key)
        const name = this.kindTarget.name.slice(0, -6)
        const beginning = `${name}[parameters_attributes][${index}]`

        const pElement = document.createElement("p")
        const labelElement = document.createElement("label")
        labelElement.htmlFor = `${beginning}[value]`
        labelElement.innerText = t(key)
        pElement.appendChild(labelElement)
        const hiddenElement = document.createElement("input")
        hiddenElement.type = "hidden"
        hiddenElement.name = `${beginning}[key]`
        hiddenElement.value = key
        pElement.appendChild(hiddenElement)

        if (parameter.kind == "select") {
          const selectElement = document.createElement("select")
          selectElement.id = `${beginning}[value]`
          selectElement.name = `${beginning}[value]`

          parameter.options.forEach((option) => {
            const optionElement = document.createElement("option")
            optionElement.value = option[0]
            optionElement.innerText = option[1]
            if (this.parametersValue[key]) {
              optionElement.selected = option[0] == this.parametersValue[key]
            } else {
              optionElement.selected = option[0] == parameter.default
            }
            selectElement.appendChild(optionElement)
          })

          pElement.appendChild(selectElement)
        } else if (parameter.kind == "string") {
          const inputElement = document.createElement("input")
          inputElement.id = `${beginning}[value]`
          inputElement.name = `${beginning}[value]`
          inputElement.value = this.parametersValue[key] || parameter.default
          inputElement.type = "text"
          pElement.appendChild(inputElement)
        } else {
          console.log({ parameter })
        }

        this.parametersTarget.appendChild(pElement)
      })
    }
  }
}
