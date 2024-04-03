import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";

export default class SidebarLeft extends Component {
  @service currentUser;
  @service router;
  @service site;

  @tracked isMovedToHeader = localStorage.getItem("isMovedToHeader") === "true";

  @tracked totalUnread = 0;
  @tracked menuPosition = { top: 0, right: 0 };
  @tracked isActive = false;

  handleDocumentClick = (event) => {
    const menuButton = document.querySelector(".sidebar-left__messages-more");
    const menuElement = document.querySelector(".sidebar-left__messages-menu");

    if (menuButton && !menuButton.contains(event.target) && menuElement) {
      if (!menuElement.contains(event.target)) {
        this.toggleMenu(event);
      }
    }
  };
  constructor() {
    super(...arguments);

    this.router.on("routeDidChange", this, this.updateUnreadMessages);
    this.updateUnreadMessages();
  }

  updateUnreadMessages() {
    if (this.currentUser !== null) {
      const messageUrl =
        "/u/" + this.currentUser.username + "/user-menu-private-messages";

      ajax(messageUrl).then((data) => {
        this.totalUnread = data.unread_notifications.length;
      });
    }
  }

  willDestroy() {
    super.willDestroy();

    this.router.off("routeDidChange", this, this.updateUnreadMessages);
  }

  get activePage() {
    return window.location.href;
  }

  get homePage() {
    return window.origin + "/";
  }

  @action
  updateMenuPosition() {
    const menuButton = document.querySelector(".sidebar-left__messages-more");

    if (menuButton) {
      const rect = menuButton.getBoundingClientRect();

      this.menuPosition = {
        top: rect.bottom,
        right: window.innerWidth - rect.right,
      };
    }
  }

  @action
  toggleMoveToHeader() {
    this.isMovedToHeader = !this.isMovedToHeader;
    localStorage.setItem("isMovedToHeader", this.isMovedToHeader.toString());
    window.location.reload(true);
  }

  @action
  toggleMenu(event) {
    event.preventDefault();
    this.isActive = !this.isActive;

    if (this.isActive) {
      this.updateMenuPosition();
      document.addEventListener("click", this.handleDocumentClick);
    } else {
      document.removeEventListener("click", this.handleDocumentClick);
    }
  }

  get concatStyle() {
    return `top: ${this.menuPosition.top}px; right: ${this.menuPosition.right}px;`;
  }
}
