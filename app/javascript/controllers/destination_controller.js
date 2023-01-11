import { Controller } from "@hotwired/stimulus"
import i18n from "../i18n"
import each from "lodash/each"

const t = i18n.scope("destination")

export default class extends Controller {
  static targets = [
    "parameters",
    "destinableId",
    "destinableType",
    "destinableLabel",
    "kind",
  ]

  static values = {
    emails: Array,
    kinds: Object,
  }

  connect() {
    console.log("CONNECT")
    this.update()
  }

  choose() {
    console.log("CHOOSE")
    this.update()
  }

  update() {
    const kind = this.kindsValue[this.kindTarget.value]

    this.destinableTypeTarget.value = kind.destinable_type
    this.destinableLabelTarget.innerText = t(kind.destinable_label)
    this.destinableIdTarget.innerText = ""
    this.parametersTarget.innerText = ""

    if (kind.destinable_type == "Email") {
      this.emailsValue.forEach((email) => {
        const optionElement = document.createElement("option")
        optionElement.value = email.id
        optionElement.innerText = email.email
        this.destinableIdTarget.appendChild(optionElement)
      })
    } else {
      console.log({ kind })
    }

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

        if (parameter.kind == "select") {
          const hiddenElement = document.createElement("input")
          hiddenElement.type = "hidden"
          hiddenElement.name = `${beginning}[key]`
          hiddenElement.value = key
          const selectElement = document.createElement("select")
          selectElement.id = `${beginning}[value]`
          selectElement.name = `${beginning}[value]`

          parameter.options.forEach((option) => {
            const optionElement = document.createElement("option")
            optionElement.value = option
            if (parameter.translate) {
              optionElement.innerText = t(option)
            } else {
              optionElement.innerText = option
            }
            optionElement.selected = option == parameter.default
            selectElement.appendChild(optionElement)
          })

          pElement.appendChild(hiddenElement)
          pElement.appendChild(selectElement)
        } else {
          console.log({ parameter })
        }

        this.parametersTarget.appendChild(pElement)
      })
    }
  }
}
