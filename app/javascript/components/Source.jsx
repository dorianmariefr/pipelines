import React from "react"
import Parameters from "./Parameters"
import Filter from "./Filter"
import map from "lodash/map"
import find from "lodash/find"
import i18n from "../i18n"

const t = i18n.scope("source")

export default ({
  removeSource,
  removable,
  allSources,
  sources,
  source,
  index,
  setSources,
  fakes,
  remove,
}) => {
  const firstKind = source.kind.split("/")[0]
  const secondKind = source.kind.split("/")[1]
  const kind = `${firstKind}/${secondKind}`
  const firstSubclasses = find(
    allSources.subclasses,
    (_value, fKind) => fKind == firstKind
  )
  const subclass = find(firstSubclasses, (_value, sKind) => sKind == secondKind)
  const keys = subclass.keys
  const parameters = subclass.parameters
  const idPrefix = `pipeline_sources_attributes_sources_${index}`
  const namePrefix = `pipeline[sources_attributes][${index}]`

  const setSource = (key, value) => {
    setSources(
      sources.map((source, sourceIndex) => {
        if (index == sourceIndex) {
          return { ...source, [key]: value }
        } else {
          return source
        }
      })
    )
  }

  return (
    <div className="card">
      <div className="p">
        <label htmlFor={`pipeline_sources_attributes_${index}_kind`}>
          {t("kind")}
        </label>

        {map(allSources.kinds, (firstKindValue, firstKind) =>
          map(firstKindValue, (_subclass, secondKind) => {
            const sourcesKind = `${firstKind}/${secondKind}`
            return (
              <div key={sourcesKind}>
                <input
                  type="radio"
                  id={`${idPrefix}_kind_${sourcesKind}`}
                  name={`${namePrefix}[kind]`}
                  value={sourcesKind}
                  checked={source.kind == sourcesKind}
                  onChange={(e) => setSource("kind", sourcesKind)}
                />
                <label
                  htmlFor={`${idPrefix}_kind_${sourcesKind}`}
                  className="ml-2 !inline-block"
                >
                  {t(`${firstKind}.${secondKind}`)}
                </label>
              </div>
            )
          })
        )}
      </div>

      <Parameters
        idPrefix={idPrefix}
        namePrefix={namePrefix}
        kind="source"
        fakes={fakes}
        parameters={parameters}
        values={source.parameters}
        setParameters={(parameters) => setSource("parameters", parameters)}
      />

      <Filter
        transform={source.transform}
        transforms={allSources.transforms}
        operators={allSources.operators}
        keys={subclass.keys}
        filterTypes={allSources.filterTypes}
        idPrefix={idPrefix}
        namePrefix={namePrefix}
        fakes={fakes}
        filterKey={source.key}
        operator={source.operator}
        value={source.value}
        filter={source.filter}
        filterType={source.filterType}
        setSource={setSource}
      />

      {removable && (
        <div className="p">
          <button role="button" onClick={removeSource}>
            {t("remove")}
          </button>
        </div>
      )}
    </div>
  )
}
