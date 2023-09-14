import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { inject as service } from "@ember/service"
import { action } from "@ember/object"

export default class HeaderCreate extends Component {
  @service currentUser

  @tracked isActive = false
  clickOutsideListener = null

  constructor() {
    super(...arguments)
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
    const dropdownButton = document.querySelector(
      "button.header-create__button"
    )
    if (dropdownButton && !dropdownButton.contains(event.target)) {
      this.toggleDropdown()
    }
  }
}
