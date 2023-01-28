import React from "react"
import Parameters from "./Parameters"
import Filter from "./Filter"
import Fake from "./Fake"
import Hint from "./Hint"
import map from "lodash/map"
import find from "lodash/find"
import i18n from "../i18n"

const t = i18n.scope("destination")

export default ({
  user,
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
  const subclass = find(allDestinations.subclasses, (_value, k) => k == kind)
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

        {map(allDestinations.kinds, (_, kind) => (
          <div key={kind}>
            <input
              type="radio"
              id={`${idPrefix}_kind_${kind}`}
              name={`${namePrefix}[kind]`}
              value={kind}
              checked={destination.kind == kind}
              onChange={(e) => setDestination("kind", kind)}
            />
            <label
              htmlFor={`${idPrefix}_kind_${kind}`}
              className="ml-2 !inline-block"
            >
              {t(kind)}
            </label>
          </div>
        ))}
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

      <input
        type="hidden"
        value={destination.destinable_type}
        name={`${namePrefix}[destinable_type]`}
      />

      <div className="p">
        <label htmlFor={`${idPrefix}_destinable_email`}>
          {t("destinable_email")}
        </label>
        <select
          id={`${idPrefix}_destinable_email`}
          name={`${namePrefix}[destinable_email]`}
          value={destination.destinable_email}
          onChange={(event) =>
            setSource("destinable_email", event.target.value)
          }
        >
          {user.emails.map((email, index) => (
            <option key={index} value={email.email}>
              {email.email}
            </option>
          ))}
        </select>
        <Fake value={fakes.destinable_email} />
        <Hint name="destinable_email" />
      </div>

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
