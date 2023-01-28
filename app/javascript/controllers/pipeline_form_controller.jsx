import { Controller } from "@hotwired/stimulus"
import React from "react"
import { createRoot } from "react-dom/client"
import PipelineForm from "../components/PipelineForm"

export default class extends Controller {
  static values = {
    pipeline: Object,
    sources: Object,
    destinations: Object,
    user: Object,
    fakes: Object,
    password: String,
  }

  connect() {
    const root = createRoot(this.element)
    root.render(
      <PipelineForm
        pipeline={this.pipelineValue}
        sources={this.sourcesValue}
        destinations={this.destinationsValue}
        user={this.userValue}
        password={this.passwordValue}
        fakes={this.fakesValue}
      />
    )
  }
}
