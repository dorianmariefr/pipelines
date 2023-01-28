import React, { useState, useEffect } from "react"
import Fake from "./Fake"
import Hint from "./Hint"
import Source from "./Source"
import Destination from "./Destination"
import i18n from "../i18n"

const t = i18n.scope("pipeline_form")

export default ({
  pipeline,
  fakes,
  password: defaultPassword,
  user: defaultUser,
  sources: allSources,
  destinations: allDestinations,
}) => {
  const [user, setUser] = useState(defaultUser)
  const [name, setName] = useState(pipeline.name)
  const [published, setPublished] = useState(pipeline.isPublished)
  const [sources, setSources] = useState(pipeline.sources)
  const [destinations, setDestinations] = useState(pipeline.destinations)
  const action = pipeline.id ? `/pipelines/${pipeline.id}` : "/pipelines"
  const method = pipeline.id ? "patch" : "post"
  const submit = pipeline.id ? t("patch") : t("post")
  const formType = user.id ? "other" : "register"

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

  const setEmail = (index, email) => {
    setUser({
      ...user,
      emails: user.emails.map((userEmail, userEmailIndex) => {
        if (userEmailIndex == index) {
          return { ...userEmail, email: email }
        } else {
          return userEmail
        }
      }),
    })
  }

  const addEmail = () => {
    setUser({
      ...user,
      emails: user.emails.concat({ email: "", isVerified: false }),
    })
  }

  const removeEmail = (index) => {
    setUser({
      ...user,
      emails: user.emails.filter(
        (_, userEmailIndex) => userEmailIndex != index
      ),
    })
  }

  useEffect(() => {
    setUser({ ...user, password: defaultPassword })
  }, [])

  return (
    <form action={action} method={method} data-form-type={formType}>
      {!user.id && (
        <>
          <div className="p">
            <label htmlFor="user_name">{t("user_name")}</label>
            <input
              type="text"
              value={user.name}
              onChange={(e) => setUser({ ...user, name: event.target.value })}
              autoComplete="name"
              id="user_name"
              name="user[name]"
            />
            <Fake value={fakes.user_name} />
            <Hint name="user_name" />
          </div>
          {user.emails.map((email, index) => (
            <div className="card" key={index}>
              <div className="p">
                <label htmlFor={`user_emails_attributes_${index}_email`}>
                  {t("user_email")}
                </label>
                <input
                  type="email"
                  value={email.email}
                  onChange={(e) => setEmail(index, event.target.value)}
                  id={`user_emails_attributes_${index}_email`}
                  name={`user[emails_attributes][${index}][email]`}
                  autoComplete="email"
                />
                <Fake value={fakes.user_email} />
                <Hint name="user_email" />
              </div>
              {user.emails.length > 1 && (
                <p>
                  <button
                    onClick={(event) => {
                      event.preventDefault()
                      removeEmail(index)
                    }}
                  >
                    {t("remove")}
                  </button>
                </p>
              )}
            </div>
          ))}
          <p>
            <button
              onClick={(event) => {
                event.preventDefault()
                addEmail()
              }}
            >
              {t("add_email")}
            </button>
          </p>
          <div className="p">
            <label htmlFor="user_password">{t("user_password")}</label>
            <input
              type="password"
              value={user.password}
              onChange={(e) =>
                setUser({ ...user, password: event.target.value })
              }
              id="user_password"
              autoComplete="new-password"
              name="user[password]"
            />
            <Fake value={fakes.user_password} />
            <Hint name="user_password" />
          </div>
        </>
      )}
      <div className="p">
        <label htmlFor="pipeline_name">{t("pipeline_name")}</label>
        <input
          type="text"
          value={name}
          onChange={(e) => setName(e.target.value)}
          id="pipeline_name"
          name="pipeline[name]"
          autoComplete="off"
          data-form-type="other"
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
          user={user}
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
