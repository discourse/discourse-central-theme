import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { action } from "@ember/object"
import { inject as service } from "@ember/service"
import discourseComputed from "discourse-common/utils/decorators"

export default class TopicListHeaderFilter extends Component {
  // @service router

  @tracked selectedOption = this.options[0]
  @tracked options = []
  @tracked isActive = false
  @tracked currentPage = (clickOutsideListener = null)

  constructor() {
    super(...arguments)

    this.options = [
      { title: "Latest", url: "/latest" },
      { title: "Top", url: "/top" },
    ]
  }

  @discourseComputed("route", "router.currentRoute")
  active(route, currentRoute) {
    if (!route) {
      return
    }

    const routeParam = this.routeParam
    if (routeParam && currentRoute) {
      return currentRoute.params["filter"] === routeParam
    }

    return this.router.isActive(route)
  }

  @action
  selectOption(option) {
    this.selectedOption = option
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
    const dropdownButton = document.querySelector(".list-filter__button")
    if (dropdownButton && !dropdownButton.contains(event.target)) {
      this.toggleDropdown()
    }
  }
}
