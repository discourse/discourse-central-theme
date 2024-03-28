import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";

export default class HeaderUser extends Component {
  @service currentUser;

  @tracked isActive = false;
  clickOutsideListener = null;

  constructor() {
    super(...arguments);
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
    const dropdownButton = document.querySelector("button.header-user__button");
    if (dropdownButton && !dropdownButton.contains(event.target)) {
      this.toggleDropdown();
    }
  }
}
