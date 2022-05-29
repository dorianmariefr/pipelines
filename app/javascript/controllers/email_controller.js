import { Controller } from "@hotwired/stimulus"
import i18n from "../i18n"

const t = i18n.scope("email")

const VALID_CLASSES = ["border-green-600", "focus:outline-green-600"]
const INVALID_CLASSES = ["border-red-600", "focus:outline-red-600"]
const REGEXP = RegExp(window.money.constants.EMAIL_REGEXP)

export default class extends Controller {
  static targets = ["input", "error"]

  static values = {
    validation: Object
  }

  connect() {
    this.inputTarget.addEventListener("input", this.input.bind(this))
  }

  disconnect() {
    this.inputTarget.removeEventListener("input", this.input.bind(this))
  }

  input() {
    if (this.inputTarget.value.trim()) {
      if (this.inputTarget.value.match(REGEXP)) {
        this.validationValue = { valid: true }
      } else {
        this.validationValue = { valid: false, message: t("must_be_valid") }
      }
    } else {
      this.validationValue = { valid: false, message: t("must_be_present") }
    }
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
}
