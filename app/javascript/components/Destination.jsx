import React from "react"
import Parameters from "./Parameters"
import Filter from "./Filter"
import map from "lodash/map"
import find from "lodash/find"
import i18n from "../i18n"

const t = i18n.scope("destination")

export default ({
  removeDestination,
  removable,
  allDestinations,
  destinations,
  destination,
  index,
  setDestinations,
  fakes,
  remove,
}) => {
  const kind = destination.kind
  const subclass = find(allDestinations, (_value, k) => k == kind)
  const parameters = subclass.parameters
  const idPrefix = `pipeline_destinations_attributes_destinations_${index}`
  const namePrefix = `pipeline[destinations_attributes][${index}]`

  const setDestination = (key, value) => {
    setDestinations(
      destinations.map((destination, destinationIndex) => {
        if (index == destinationIndex) {
          return { ...destination, [key]: value }
        } else {
          return destination
        }
      })
    )
  }

  return (
    <div className="card">
      <div className="p">
        <label htmlFor={`pipeline_destinations_attributes_${index}_kind`}>
          {t("kind")}
        </label>

        {map(allDestinations.kinds, (firstKindValue, firstKind) =>
          map(firstKindValue, (_subclass, secondKind) => {
            const destinationsKind = `${firstKind}/${secondKind}`
            return (
              <div key={destinationsKind}>
                <input
                  type="radio"
                  id={`${idPrefix}_kind_${destinationsKind}`}
                  name={`${namePrefix}[kind]`}
                  value={destinationsKind}
                  checked={destination.kind == destinationsKind}
                  onChange={(e) => setDestination("kind", destinationsKind)}
                />
                <label
                  htmlFor={`${idPrefix}_kind_${destinationsKind}`}
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
        kind="destination"
        fakes={fakes}
        parameters={parameters}
        values={destination.parameters}
        setParameters={(parameters) => setDestination("parameters", parameters)}
      />

      {removable && (
        <div className="p">
          <button role="button" onClick={removeDestination}>
            {t("remove")}
          </button>
        </div>
      )}
    </div>
  )
}
