import { Controller } from "@hotwired/stimulus"
import intlTelInput from "intl-tel-input"
import i18n from "../i18n"

const t = i18n.scope("phone")
const IP_INFO_TOKEN = "15e3c482e1332b"
const DEFAULT_COUNTRY_CODE = "us"

const ERRORS = {
  0: t("is_possible"),
  1: t("invalid_country_code"),
  2: t("too_short"),
  3: t("too_long"),
  4: t("is_possible_local_only"),
  5: t("invalid_length"),
  "-99": t("invalid_phone_number"),
}

const VALID_CLASSES = ["border-green-600", "focus:outline-green-600"]
const INVALID_CLASSES = ["border-red-600", "focus:outline-red-600"]

export default class extends Controller {
  static targets = ["input", "error", "hidden"]

  static values = {
    validation: Object,
  }

  connect() {
    this.iti = intlTelInput(this.inputTarget, {
      utilsScript: require("intl-tel-input/build/js/utils"),
      initialCountry: "auto",
      geoIpLookup: async function (success) {
        try {
          const response = await fetch(
            `https://ipinfo.io?token=${IP_INFO_TOKEN}`,
            {
              headers: {
                Accept: "application/json",
              },
            }
          )
          const json = await response.json()
          const countryCode = (json && json.country) || DEFAULT_COUNTRY_CODE
          success(countryCode)
        } catch {
          success(DEFAULT_COUNTRY_CODE)
        }
      },
    })

    this.inputTarget.addEventListener("input", this.input.bind(this))

    this.observer = new MutationObserver(this.mutate.bind(this))
    this.observer.observe(this.inputTarget, { attributes: true })
  }

  disconnect() {
    this.iti = null
    this.inputTarget.removeEventListener("input", this.input.bind(this))
    this.observer.disconnect()
  }

  mutate() {
    if (this.inputTarget.value.trim()) {
      this.input()
    }
  }

  input() {
    if (this.inputTarget.value.trim()) {
      if (this.iti.isValidNumber()) {
        this.validationValue = { valid: true, message: "" }
        this.hiddenTarget.value = this.iti.getNumber()
      } else {
        const message = ERRORS[this.iti.getValidationError()]
        this.validationValue = { valid: false, message: message }
        this.hiddenTarget.value = ""
      }
    } else {
      this.validationValue = { valid: false, message: t("must_be_present") }
      this.hiddenTarget.value = ""
    }
  }

  validationValueChanged(validation) {
    const input = this.inputTarget
    const error = this.errorTarget

    if (validation.valid === true) {
      input.classList.add(...VALID_CLASSES)
      input.classList.remove(...INVALID_CLASSES)
      error.innerText = ""
    } else if (validation.valid === false) {
      input.classList.add(...INVALID_CLASSES)
      input.classList.remove(...VALID_CLASSES)
      error.innerText = validation.message || ""
    } else {
      input.classList.remove(...VALID_CLASSES)
      input.classList.remove(...INVALID_CLASSES)
      error.innerText = ""
    }
  }
}
