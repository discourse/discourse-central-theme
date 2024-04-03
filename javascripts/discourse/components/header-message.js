import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action, set } from "@ember/object";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";

export default class HeaderMessage extends Component {
  @service currentUser;

  @tracked isMovedToHeader = localStorage.getItem("isMovedToHeader") === "true";
  @tracked menuPosition = { top: 0, right: 0 };
  @tracked submenuIsActive = false;

  @tracked messages = null;
  @tracked selectedTabIndex = 0;
  @tracked loading = null;

  @tracked allUnread = localStorage.getItem(`inboxes_unread`) ?? 0;

  @tracked isActive = false;
  @tracked inboxes = [];
  clickOutsideListener = null;

  tagName = "";

  handleDocumentClick2 = (event) => {
    const menuButton = document.querySelector(".header-message__more");
    const menuElement = document.querySelector(".header-message__submenu");

    if (menuButton && !menuButton.contains(event.target) && menuElement) {
      if (!menuElement.contains(event.target)) {
        this.toggleSubmenu(event);
      }
    }
  };
  constructor() {
    super(...arguments);
    const inboxes = this.currentUser.groups.filter(
      (inbox) => inbox.has_messages
    );

    const myInbox = { name: "My Inbox" };
    inboxes.unshift(myInbox);

    this.inboxes = inboxes;
    this.inboxes.forEach((inbox, index) => {
      const localStorageKey = `inbox_${index}_unread`;
      inbox.unread_total = localStorage.getItem(localStorageKey) ?? 0;
    });

    this.loadInbox(this.selectedTabIndex);
  }

  get selectedInbox() {
    return this.inboxes[this.selectedTabIndex];
  }

  @action
  toggleMoveToHeader() {
    this.isMovedToHeader = !this.isMovedToHeader;
    localStorage.setItem("isMovedToHeader", this.isMovedToHeader.toString());

    window.location.reload(true);
  }

  @action
  updateMenuPosition() {
    const menuButton = document.querySelector(".header-message__more");

    if (menuButton) {
      const rect = menuButton.getBoundingClientRect();

      this.menuPosition = {
        top: rect.bottom,
        right: window.innerWidth - rect.right,
      };
    }
  }

  @action
  toggleSubmenu(event) {
    event.preventDefault();
    this.submenuIsActive = !this.submenuIsActive;

    if (this.submenuIsActive) {
      this.updateMenuPosition();
      document.addEventListener("click", this.handleDocumentClick2);
    } else {
      document.removeEventListener("click", this.handleDocumentClick2);
    }
  }

  get concatStyle() {
    return `top: ${this.menuPosition.top}px; right: ${this.menuPosition.right}px;`;
  }

  @action
  async loadInbox(index) {
    this.loading = true;

    const selectedInbox = this.inboxes[index];

    if (selectedInbox) {
      try {
        const messages = await this.fetchMessages(selectedInbox);

        messages.unread_total = 0;

        messages.topic_list.topics.forEach((topic) => {
          topic.posters.forEach((poster) => {
            const matchingUser = messages.users.find(
              (user) => user.id === poster.user_id
            );

            if (matchingUser) {
              Object.assign(poster, matchingUser);
            }
          });

          topic.first_poster = topic.posters[0];
          topic.last_poster = topic.posters[topic.posters.length - 1];

          topic.no_replies =
            topic.participants.length === 1 && topic.posters.length === 1;

          if (Number.isInteger(topic.unread_posts) && topic.unread_posts > 0) {
            messages.unread_total++;
            topic.unread = 1;
          } else {
            topic.unread = 0;
          }
        });

        const inboxKey = `inbox_${index}_unread`;
        const previousUnreadCount = Number(selectedInbox.unread_total) || 0;
        const newUnreadCount = Number(messages.unread_total);

        localStorage.setItem(inboxKey, messages.unread_total);

        set(this.inboxes[index], "unread_total", messages.unread_total);

        this.allUnread = this.allUnread - previousUnreadCount + newUnreadCount;
        localStorage.setItem(`inboxes_unread`, this.allUnread);

        // Update the component state
        this.messages = { ...messages };

        // Loading is done
        this.loading = false;
      } catch (error) {
        // Loading is done (with error)
        this.loading = false;
      }
    }
  }

  async fetchMessages(selectedInbox) {
    const url =
      selectedInbox.name === "My Inbox"
        ? `/topics/private-messages/${this.currentUser.username}.json`
        : `/topics/private-messages-group/${this.currentUser.username}/${selectedInbox.name}.json`;

    return await ajax(url);
  }

  @action
  selectTab(index) {
    if (this.selectedTabIndex === index) {
      this.loadInbox(index);
    } else {
      this.selectedTabIndex = index;
      this.loadInbox(index);
    }
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

  isClickOutsideMenu(target) {
    const menuElement = document.querySelector(".header-message__menu");
    return menuElement && !menuElement.contains(target);
  }

  handleDocumentClick(event) {
    const dropdownButton = document.querySelector(
      "button.header-message__button"
    );
    if (
      dropdownButton &&
      !dropdownButton.contains(event.target) &&
      this.isClickOutsideMenu(event.target)
    ) {
      this.toggleDropdown();
    }
  }
}
