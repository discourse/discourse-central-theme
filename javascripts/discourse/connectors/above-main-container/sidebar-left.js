import Component from "@glimmer/component"
import { ajax } from "discourse/lib/ajax"
import { tracked } from "@glimmer/tracking"
import { inject as service } from "@ember/service"

export default class SidebarLeft extends Component {
  @service currentUser
  @service router

  @tracked totalUnread = 0

  constructor() {
    super(...arguments)

    this.router.on("routeDidChange", this, this.updateUnreadMessages)
    this.updateUnreadMessages()
  }

  updateUnreadMessages() {
    if (this.currentUser !== null) {
      const messageUrl =
        "/u/" + this.currentUser.username + "/user-menu-private-messages"

      ajax(messageUrl).then((data) => {
        this.totalUnread = data.unread_notifications.length
      })
    }
  }

  willDestroy() {
    super.willDestroy()

    this.router.off("routeDidChange", this, this.updateUnreadMessages)
  }

  get activePage() {
    return window.location.href
  }

  get homePage() {
    return window.origin + "/"
  }
}
