import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import User from "discourse/models/user";

export default class SidebarLeftUser extends Component {
  @tracked isActive = false;
  @tracked currentUser = null;
  clickOutsideListener = null;

  constructor() {
    super(...arguments);
    this.currentUser = User.current();
  }

  @action
  toggleDropdown() {
    this.isActive = !this.isActive;
    if (this.isActive) {
      this.clickOutsideListener = this.handleDocumentClick.bind(this);
      document.addEventListener("click", this.clickOutsideListener);
    } else {
      document.removeEventListener("click", this.clickOutsideListener);
    }
  }

  handleDocumentClick(event) {
    const dropdownButton = document.querySelector("button.sidebar-left__user");
    if (dropdownButton && !dropdownButton.contains(event.target)) {
      this.toggleDropdown();
    }
  }
}
