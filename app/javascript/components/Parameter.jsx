import React from "react"

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
  const inputId = `${idPrefix}_parameters_attributes_${index}_value`
  const inputName = `${namePrefix}[parameters_attributes][${index}][value]`

  const onChange = (event) => {
    setParameter(parameterKey, event.target.value)
  }

  return (
    <div className="p">
      <label htmlFor={inputId}>{t(parameterKey)}</label>
      {parameter.kind == "string" && (
        <input
          type="text"
          id={inputId}
          name={inputName}
          defaultValue={defaultValue}
          onChange={onChange}
        />
      )}
      {parameter.kind == "text" && (
        <textarea
          className="min-h-[10rem]"
          id={inputId}
          name={inputName}
          defaultValue={defaultValue}
          onChange={onChange}
        />
      )}
      {parameter.kind == "select" && (
        <select
          id={inputId}
          name={inputName}
          defaultValue={defaultValue}
          onChange={onChange}
        >
          {parameter.options.map((option, index) => (
            <option key={index} disabled={option[2]} defaultValue={option[0]}>
              {parameter.translate ? t(option[1]) : option[1]}
            </option>
          ))}
        </select>
      )}
      <Fake defaultValue={fakes[parameterKey]} />
      <Hint name={parameterKey} />
    </div>
  )
}
