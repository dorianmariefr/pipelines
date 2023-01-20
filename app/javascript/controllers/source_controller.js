import { Controller } from "@hotwired/stimulus"
import i18n from "../i18n"
import each from "lodash/each"

const t = i18n.scope("source")

export default class extends Controller {
  static outlets = ["destination"]

  static targets = ["parameters", "kind", "preview", "filter", "parameter"]

  static values = {
    kind: String,
    kinds: Object,
    parameters: Object,
  }

  connect() {
    this.update()
    this.preview()
  }

  choose() {
    this.update()
    this.preview()
  }

  async preview() {
    const csrfToken = document.querySelector("[name='csrf-token']").content
    const kind = this.kindTarget.value
    const filter = this.filterTarget.value
    const parameters = this.parameterTargets.map((parameterTarget) => {
      return { key: parameterTarget.dataset.key, value: parameterTarget.value }
    })

    try {
      const response = await fetch("/sources/preview", {
        method: "POST",
        headers: {
          "X-CSRF-Token": csrfToken,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          source: {
            kind: kind,
            filter: filter,
            parameters_attributes: parameters,
          },
        }),
      })

      const json = await response.json()

      this.previewTarget.innerText = JSON.stringify(json, null, 2)
    } catch (e) {
      this.previewTarget.innerText = e.message
    }
  }

  value(key, parameter) {
    return this.parametersValue[key] || parameter.default
  }

  update() {
    this.kindValue = this.kindTarget.value
    const kind = this.kindsValue[this.kindValue]
    window.dispatchEvent(
      new CustomEvent("source-update", {
        detail: { kind: this.kindValue },
      })
    )

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
          selectElement.dataset.action = "source#preview"
          selectElement.dataset.sourceTarget = "parameter"
          selectElement.dataset.key = key

          parameter.options.forEach((option) => {
            const optionElement = document.createElement("option")
            optionElement.value = option[0]
            optionElement.innerText = option[1]
            if (option.length > 2) {
              optionElement.disabled = option[2]
            }
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
          inputElement.dataset.action = "source#preview"
          inputElement.dataset.sourceTarget = "parameter"
          inputElement.dataset.key = key
          pElement.appendChild(inputElement)
        } else if (parameter.kind == "text") {
          const inputElement = document.createElement("textarea")
          inputElement.id = `${beginning}[value]`
          inputElement.name = `${beginning}[value]`
          inputElement.value = this.value(key, parameter)
          inputElement.dataset.action = "source#preview"
          inputElement.dataset.sourceTarget = "parameter"
          inputElement.dataset.key = key
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
