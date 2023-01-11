import { Application } from "@hotwired/stimulus"

console.log("APPLICATION START")
const application = Application.start()

application.debug = true
window.Stimulus = application

export { application }
