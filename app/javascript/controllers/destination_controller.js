import { Controller } from "@hotwired/stimulus"
import i18n from "../i18n"
import each from "lodash/each"
import isObject from "lodash/isObject"
import values from "lodash/values"

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
    parameters: Object,
    sourceKind: String,
  }

  connect() {
    this.update()
  }

  choose() {
    this.update()
  }

  sourceKindUpdate(event) {
    this.sourceKindValue = event.detail.kind
    this.parametersValue = {}
    this.update()
  }

  value(key, parameter) {
    if (isObject(parameter.default)) {
      if (this.sourceKindValue) {
        return (
          this.parametersValue[key] || parameter.default[this.sourceKindValue]
        )
      } else {
        return this.parametersValue[key] || values(parameter.default)[0]
      }
    } else {
      return this.parametersValue[key] || parameter.default
    }
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
        if (!email.verified) {
          optionElement.disabled = true
          optionElement.innerText += t("not_verified")
        }
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
            if (option.length > 2) {
              optionElement.disabled = option[2]
            }
            optionElement.selected = option[0] == this.value(key, parameter)
            selectElement.appendChild(optionElement)
          })

          pElement.appendChild(selectElement)
        } else if (parameter.kind == "string") {
          const inputElement = document.createElement("input")
          inputElement.id = `${beginning}[value]`
          inputElement.name = `${beginning}[value]`
          inputElement.value = this.value(key, parameter)
          inputElement.type = "text"
          pElement.appendChild(inputElement)
        } else if (parameter.kind == "text") {
          const inputElement = document.createElement("textarea")
          inputElement.id = `${beginning}[value]`
          inputElement.name = `${beginning}[value]`
          inputElement.value = this.value(key, parameter)
          pElement.appendChild(inputElement)
        } else {
          console.log({ parameter })
        }

        const hintElement = document.createElement("div")
        hintElement.classList.add("text-gray-600")
        hintElement.innerHTML = t(`${key}_hint_html`)
        pElement.appendChild(hintElement)

        this.parametersTarget.appendChild(pElement)
      })
    }
  }
}
