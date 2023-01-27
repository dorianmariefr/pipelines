import React from "react"
import i18n from "../i18n"
import Fake from "./Fake"
import Hint from "./Hint"

const t = i18n.scope("filter")

export default ({
  transforms,
  transform,
  operators,
  keys,
  filterTypes,
  idPrefix,
  namePrefix,
  fakes,
  filterKey,
  operator,
  value,
  filter,
  filterType,
  setSource,
}) => {
  return (
    <>
      <div className="p">
        <label htmlFor={`${idPrefix}_filter_type`}>{t("filter_type")}</label>
        <select
          id={`${idPrefix}_filter_type`}
          name={`${namePrefix}[filter_type]`}
          value={filterType}
          onChange={(event) => setSource("filterType", event.target.value)}
        >
          {filterTypes.map((filterType, index) => (
            <option key={index} value={filterType}>
              {t(filterType)}
            </option>
          ))}
        </select>
        <Fake value={fakes.filter_type} />
        <Hint name="filter_type" />
      </div>

      {filterType == "simple" && (
        <>
          <div className="p">
            <label htmlFor={`${idPrefix}_key`}>{t("key")}</label>
            <select
              id={`${idPrefix}_key`}
              name={`${namePrefix}[key]`}
              value={filterKey}
              onChange={(event) => setSource("key", event.target.value)}
            >
              {keys.map((key, index) => (
                <option key={index} value={key}>
                  {key}
                </option>
              ))}
            </select>
            <Fake value={fakes.key} />
            <Hint name="key" />
          </div>

          <div className="p">
            <label htmlFor={`${idPrefix}_transform`}>{t("transform")}</label>
            <select
              id={`${idPrefix}_transform`}
              name={`${namePrefix}[transform]`}
              value={transform}
              onChange={(event) => setSource("transform", event.target.value)}
            >
              {transforms.map((transform, index) => (
                <option key={index} value={transform}>
                  {t(transform)}
                </option>
              ))}
            </select>
            <Fake value={fakes.transform} />
            <Hint name="transform" />
          </div>

          <div className="p">
            <label htmlFor={`${idPrefix}_operator`}>{t("operator")}</label>
            <select
              id={`${idPrefix}_operator`}
              name={`${namePrefix}[operator]`}
              value={operator}
              onChange={(event) => setSource("operator", event.target.value)}
            >
              {operators.map((operator, index) => (
                <option key={index} value={operator}>
                  {t(operator)}
                </option>
              ))}
            </select>
            <Fake value={fakes.operator} />
            <Hint name="operator" />
          </div>

          <div className="p">
            <label htmlFor={`${idPrefix}_value`}>{t("value")}</label>
            <input
              type="text"
              id={`${idPrefix}_value`}
              name={`${namePrefix}[value]`}
              value={value}
              onChange={(event) => setSource("value", event.target.value)}
            />
            <Fake value={fakes.value} />
            <Hint name="value" />
          </div>
        </>
      )}

      {filterType == "code" && (
        <div className="p">
          <label htmlFor={`${idPrefix}_filter`}>{t("filter")}</label>
          <input
            type="text"
            id={`${idPrefix}_filter`}
            name={`${namePrefix}[filter]`}
            filter={filter}
            onChange={(event) => setSource("filter", event.target.filter)}
          />
          <Fake value={fakes.filter} />
          <Hint name="filter" />
        </div>
      )}
    </>
  )
}
