import Component from "@ember/component"
import { tracked } from "@glimmer/tracking"
import { action } from "@ember/object"

export default class SidebarLeftSection extends Component {
  @tracked isToggled = true

  constructor() {
    super(...arguments)
    // Retrieve the toggle state from localStorage
    const storedState = localStorage.getItem("sectionToggleState")
    if (storedState) {
      this.isToggled = JSON.parse(storedState)
    }
  }

  @action
  toggleSection() {
    this.isToggled = !this.isToggled
    // Save the toggle state to localStorage
    localStorage.setItem("sectionToggleState", JSON.stringify(this.isToggled))
  }

  tagName = ""
}
