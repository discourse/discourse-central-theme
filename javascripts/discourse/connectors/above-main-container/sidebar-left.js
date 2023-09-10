import Component from "@glimmer/component"
import User from "discourse/models/user"
import { tracked } from "@glimmer/tracking"

export default class SidebarLeft extends Component {
  @tracked currentUser = null

  constructor() {
    super(...arguments)
    this.currentUser = User.current()
  }

  get activePage() {
    return window.location.href
  }

  get homePage() {
    return window.origin + "/"
  }
}
