import { Controller } from "@hotwired/stimulus";
import intlTelInput from "intl-tel-input";
import i18n from "../i18n";

const t = i18n.scope("phone");

const ERRORS = {
  0: t("is_possible"),
  1: t("invalid_country_code"),
  2: t("too_short"),
  3: t("too_long"),
  4: t("is_possible_local_only"),
  5: t("invalid_length"),
  "-99": t("invalid_phone_number"),
};

const VALID_CLASSES = ["border-green-600", "focus:outline-green-600"];
const INVALID_CLASSES = ["border-red-600", "focus:outline-red-600"];

export default class extends Controller {
  static targets = ["input", "error", "hidden"];

  static values = {
    validation: Object,
  };

  connect() {
    const INITIAL_COUNTRY = window.money.constants.INITIAL_COUNTRY;

    this.iti = intlTelInput(this.inputTarget, {
      initialCountry: INITIAL_COUNTRY,
      utilsScript: require("intl-tel-input/build/js/utils"),
    });

    this.inputTarget.addEventListener("input", this.input.bind(this));
  }

  disconnect() {
    this.iti = null;
    this.inputTarget.removeEventListener("input", this.input.bind(this));
  }

  input() {
    if (this.inputTarget.value.trim()) {
      if (this.iti.isValidNumber()) {
        this.validationValue = { valid: true, message: "" };
        this.hiddenTarget.value = this.iti.getNumber();
      } else {
        const message = ERRORS[this.iti.getValidationError()];
        this.validationValue = { valid: false, message: message };
        this.hiddenTarget.value = "";
      }
    } else {
      this.validationValue = { valid: false, message: t("must_be_present") };
      this.hiddenTarget.value = "";
    }
  }

  validationValueChanged(validation) {
    const input = this.inputTarget;
    const error = this.errorTarget;

    if (validation.valid === true) {
      input.classList.add(...VALID_CLASSES);
      input.classList.remove(...INVALID_CLASSES);
      error.innerText = "";
    } else if (validation.valid === false) {
      input.classList.add(...INVALID_CLASSES);
      input.classList.remove(...VALID_CLASSES);
      error.innerText = validation.message || "";
    } else {
      input.classList.remove(...VALID_CLASSES);
      input.classList.remove(...INVALID_CLASSES);
      error.innerText = "";
    }
  }
}
