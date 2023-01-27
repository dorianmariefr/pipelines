import React from "react"
import i18n from "../i18n"

const t = i18n.scope("hint")

export default ({ name }) => {
  return <div className="text-gray-600 text-sm">{t(name)}</div>
}
