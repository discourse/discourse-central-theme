import Component from "@ember/component"
import { tracked } from "@glimmer/tracking"
import { action } from "@ember/object"

export default class AccordionComponent extends Component {
  @tracked isActive = true

  constructor() {
    super(...arguments)
    // Retrieve the toggle state from localStorage
    const storedState = localStorage.getItem("accordionState")
    if (storedState) {
      this.isActive = JSON.parse(storedState)
    }
  }

  @action
  toggleAccordion() {
    this.isActive = !this.isActive
    // Save the toggle state to localStorage
    localStorage.setItem("accordionState", JSON.stringify(this.isActive))
  }

  tagName = ""
}
