import React, { useState, useEffect } from "react"

import i18n from "../i18n"
import Fake from "./Fake"
import Hint from "./Hint"

const t = i18n.scope("parameter")

export default ({
  idPrefix,
  namePrefix,
  parameterKey,
  index,
  parameter,
  defaultValue,
  fakes,
  setParameter,
}) => {
  const [value, setValue] = useState(defaultValue)
  const inputId = `${idPrefix}_parameters_attributes_${index}_value`
  const inputName = `${namePrefix}[parameters_attributes][${index}][value]`
  const hiddenName = `${namePrefix}[parameters_attributes][${index}][key]`

  const onChange = (event) => {
    setParameter(parameterKey, event.target.value)
    setValue(event.target.value)
  }

  useEffect(() => {
    setParameter(parameterKey, defaultValue)
    setValue(defaultValue)
  }, [defaultValue])

  return (
    <div className="p">
      <input type="hidden" name={hiddenName} value={parameterKey} />
      <label htmlFor={inputId}>{t(parameterKey)}</label>
      {parameter.kind == "string" && (
        <input
          type="text"
          id={inputId}
          name={inputName}
          value={value}
          onChange={onChange}
          autocomplete="off"
          data-form-type="other"
        />
      )}
      {parameter.kind == "text" && (
        <textarea
          className="min-h-[10rem]"
          id={inputId}
          name={inputName}
          value={value}
          onChange={onChange}
          autocomplete="off"
          data-form-type="other"
        />
      )}
      {parameter.kind == "select" && (
        <select
          id={inputId}
          name={inputName}
          value={value}
          onChange={onChange}
          autocomplete="off"
          data-form-type="other"
        >
          {parameter.options.map((option, index) => (
            <option key={index} disabled={option[2]} value={option[0]}>
              {parameter.translate ? t(option[1]) : option[1]}
            </option>
          ))}
        </select>
      )}
      <Fake value={fakes[parameterKey]} />
      <Hint name={parameterKey} />
    </div>
  )
}
