import { Controller } from "@hotwired/stimulus"

const CURRENT_USER_ID = window.currentUser.id

export default class extends Controller {
  connect() {
    if (CURRENT_USER_ID) {
      const csrfToken = document.querySelector("[name='csrf-token']").content
      const timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone

      fetch(`/users/${CURRENT_USER_ID}.json`, {
        method: "PATCH",
        redirect: "manual",
        headers: {
          "X-CSRF-Token": csrfToken,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ user: { time_zone: timeZone } }),
      })
    }
  }
}
