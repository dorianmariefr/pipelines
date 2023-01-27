import React from "react"
import i18n from "../i18n"

const t = i18n.scope("fake")

export default ({ value }) => {
  return (
    <div className="text-gray-600 italic text-sm">
      {t("fake", { value: value })}
    </div>
  )
}
