import React, { useState } from "react"
import Fake from "./Fake"
import Hint from "./Hint"
import Source from "./Source"
import Destination from "./Destination"
import i18n from "../i18n"

const t = i18n.scope("pipeline_form")

export default ({
  pipeline,
  fakes,
  sources: allSources,
  destinations: allDestinations,
}) => {
  const [name, setName] = useState(pipeline.name)
  const [published, setPublished] = useState(pipeline.isPublished)
  const [sources, setSources] = useState(pipeline.sources)
  const [destinations, setDestinations] = useState(pipeline.destinations)
  const action = pipeline.id ? `/pipelines/${pipeline.id}` : "/pipelines"
  const method = pipeline.id ? "patch" : "post"
  const submit = pipeline.id ? t("patch") : t("post")

  const addSource = (event) => {
    event.preventDefault()
    setSources(sources.concat(sources[0]))
  }

  const removeSource = (index) => {
    setSources(sources.filter((_, i) => i != index))
  }

  const addDestination = (event) => {
    event.preventDefault()
    setDestinations(destinations.concat(destinations[0]))
  }

  const removeDestination = (index) => {
    setDestinations(destinations.filter((_, i) => i != index))
  }

  return (
    <form action={action} method={method}>
      <div className="p">
        <label htmlFor="pipeline_name">{t("pipeline_name")}</label>
        <input
          type="text"
          value={name}
          onChange={(e) => setName(e.target.value)}
          id="pipeline_name"
          name="pipeline[name]"
        />
        <Fake value={fakes.name} />
        <Hint name="name" />
      </div>
      <div className="p">
        <label>{t("pipeline_published")}</label>
        <div>
          <input
            type="radio"
            id="pipeline_published_true"
            name="pipeline[published]"
            value="true"
            checked={published}
            onChange={() => setPublished(true)}
          />
          <label
            htmlFor="pipeline_published_true"
            className="!inline-block mx-2"
          >
            {t("yes")}
          </label>
        </div>
        <div>
          <input
            type="radio"
            id="pipeline_published_false"
            name="pipeline[published]"
            value="false"
            checked={!published}
            onChange={() => setPublished(false)}
          />
          <label
            htmlFor="pipeline_published_false"
            className="!inline-block mx-2"
          >
            {t("no")}
          </label>
        </div>
        <Hint name="published" />
      </div>

      {sources.map((source, index) => (
        <Source
          key={index}
          sources={sources}
          allSources={allSources}
          source={source}
          index={index}
          fakes={fakes}
          setSources={setSources}
          removable={sources.length > 1}
          removeSource={(event) => {
            event.preventDefault()
            removeSource(index)
          }}
        />
      ))}

      <div className="p">
        <button onClick={addSource}>{t("add_source")}</button>
      </div>

      {destinations.map((destination, index) => (
        <Destination
          key={index}
          destinations={destinations}
          allDestinations={allDestinations}
          destination={destination}
          index={index}
          fakes={fakes}
          setDestinations={setDestinations}
          removable={destinations.length > 1}
          removeDestination={(event) => {
            event.preventDefault()
            removeDestination(index)
          }}
        />
      ))}

      <div className="p">
        <button onClick={addDestination}>{t("add_destination")}</button>
      </div>

      <input type="submit" className="button--primary" value={submit} />
    </form>
  )
}
