import React, { useEffect } from "react"
import map from "lodash/map"
import each from "lodash/each"
import Parameter from "./Parameter"

export default ({
  idPrefix,
  namePrefix,
  kind,
  parameters,
  values,
  setParameters,
  fakes,
}) => {
  const setParameter = (key, value) => {
    if (values.find((valueValue) => valueValue.key == key)) {
      setParameters(
        values.map((valueValue) => {
          if (valueValue.key == key) {
            return { key: key, value: value }
          } else {
            return valueValue
          }
        })
      )
    } else {
      setParameters(values.concat({ key: key, value: value }))
    }
  }

  const bodyFormat =
    values.find((value) => value.key == "body_format")?.value || "html"

  return (
    <>
      {map(parameters, (parameter, parameterKey) => (
        <Parameter
          idPrefix={idPrefix}
          namePrefix={namePrefix}
          key={parameterKey}
          parameterKey={parameterKey}
          index={map(parameters, (parameter) => parameter).indexOf(parameter)}
          parameter={parameter}
          setParameter={setParameter}
          fakes={fakes}
          defaultValue={
            parameterKey == "body"
              ? parameter.default[bodyFormat]
              : parameter.default
          }
        />
      ))}
    </>
  )
}
