import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import User from "discourse/models/user"
import { action } from "@ember/object"

export default class HeaderUser extends Component {
  @tracked isActive = false
  @tracked currentUser = null
  clickOutsideListener = null

  constructor() {
    super(...arguments)
    this.currentUser = User.current()
  }

  @action
  toggleDropdown() {
    this.isActive = !this.isActive
    if (this.isActive) {
      this.clickOutsideListener = this.handleDocumentClick.bind(this)
      document.addEventListener("click", this.clickOutsideListener)
    } else {
      document.removeEventListener("click", this.clickOutsideListener)
    }
  }

  handleDocumentClick(event) {
    const dropdownButton = document.querySelector("button.sidebar-left__user")
    if (dropdownButton && !dropdownButton.contains(event.target)) {
      this.toggleDropdown()
    }
  }
}
