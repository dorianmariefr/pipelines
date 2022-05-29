import { Controller } from "@hotwired/stimulus"
import i18n from "../i18n"

const t = i18n.scope("name")

const VALID_CLASSES = ["border-green-600", "focus:outline-green-600"]
const INVALID_CLASSES = ["border-red-600", "focus:outline-red-600"]

export default class extends Controller {
  static targets = ["input", "error", "show", "hide"]

  static values = {
    validation: Object,
    type: { type: String, default: "password" }
  }

  connect() {
    this.inputTarget.addEventListener("input", this.input.bind(this))
  }

  disconnect() {
    this.inputTarget.removeEventListener("input", this.input.bind(this))
  }

  input() {
    if (this.inputTarget.value.trim()) {
      this.validationValue = { valid: true }
    } else {
      this.validationValue = { valid: false, message: t("must_be_present") }
    }
  }

  show(event) {
    event.preventDefault()
    this.typeValue = "text"
  }

  hide(event) {
    event.preventDefault()
    this.typeValue = "password"
  }

  validationValueChanged(validation) {
    const input = this.inputTarget
    const error = this.errorTarget

    if (validation.valid === true) {
      this.inputTarget.classList.add(...VALID_CLASSES)
      this.inputTarget.classList.remove(...INVALID_CLASSES)
      this.errorTarget.innerText = ""
    } else if (validation.valid === false) {
      this.inputTarget.classList.add(...INVALID_CLASSES)
      this.inputTarget.classList.remove(...VALID_CLASSES)
      this.errorTarget.innerText = validation.message || ""
    } else {
      this.inputTarget.classList.remove(...VALID_CLASSES)
      this.inputTarget.classList.remove(...INVALID_CLASSES)
      this.errorTarget.innerText = ""
    }
  }

  typeValueChanged(type) {
    this.inputTarget.type = type

    if (type === "text") {
      this.showTarget.classList.add("hidden")
      this.hideTarget.classList.remove("hidden")
    } else {
      this.hideTarget.classList.add("hidden")
      this.showTarget.classList.remove("hidden")
    }
  }
}
