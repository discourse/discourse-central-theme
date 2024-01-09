import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { LinkTo } from "@ember/routing";
import { inject as service } from "@ember/service";
import DButton from "discourse/components/d-button";
import concatClass from "discourse/helpers/concat-class";
import { ajax } from "discourse/lib/ajax";
import { defaultHomepage } from "discourse/lib/utilities";
import icon from "discourse-common/helpers/d-icon";
import i18n from "discourse-common/helpers/i18n";
import { bind } from "discourse-common/utils/decorators";
import eq from "truth-helpers/helpers/eq";
import SidebarLeftCategories from "../components/sidebar-left-categories";
import SidebarLeftFooter from "../components/sidebar-left-footer";

export default class SidebarLeft extends Component {
  @service currentUser;
  @service router;
  @service site;
  @service composer;
  @service customSidebarState;

  @tracked isMovedToHeader = localStorage.getItem("isMovedToHeader") === "true";
  @tracked totalUnread = 0;
  @tracked menuIsActive = false;

  constructor() {
    super(...arguments);
    this.router.on("routeWillChange", this, this.closeSidebar);
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

  closeSidebar() {
    // closes the open sidebar when at tablet width
    this.customSidebarState.setTo(false);
  }

  willDestroy() {
    super.willDestroy();
    this.router.off("routeWillChange", this, this.closeSidebar);
    this.router.off("routeDidChange", this, this.updateUnreadMessages);
  }

  get homepageRoute() {
    const homepage = defaultHomepage();
    return `discovery.${homepage}`;
  }

  @action
  createTopic() {
    this.composer.openNewTopic({
      preferDraft: true,
    });
  }

  @action
  isActiveLink(linkRouteName) {
    const currentRouteName = this.router?.currentRouteName;
    return currentRouteName === linkRouteName ? "active" : "";
  }

  @action
  toggleMenu(state) {
    if (state !== undefined) {
      this.menuIsActive = state;
    } else {
      this.menuIsActive = !this.menuIsActive;
    }

    if (this.menuIsActive) {
      this.startListening();
    } else {
      this.stopListening();
    }
  }

  @action
  closeMenuOnRouteChange() {
    this.toggleMenu(false);
  }

  @bind
  startListening() {
    document.addEventListener("click", this.listenForClickOutside);
    this.router.on("routeWillChange", this.closeMenuOnRouteChange);
  }

  @bind
  stopListening() {
    document.removeEventListener("click", this.listenForClickOutside);
    this.router.off("routeWillChange", this.closeMenuOnRouteChange);
  }

  @bind
  listenForClickOutside(event) {
    const menuElement = document.querySelector(".sidebar-left__messages-menu");

    if (!menuElement?.contains(event.target)) {
      this.toggleMenu(false);
    }
  }

  @action
  toggleMoveToHeader() {
    this.isMovedToHeader = !this.isMovedToHeader;
    localStorage.setItem("isMovedToHeader", this.isMovedToHeader.toString());
    window.location.reload(true);
  }

  <template>
    <nav class="sidebar-left">
      {{!-- <div class="sidebar-left__section">
    {{sidebar-left-user}}
  </div> --}}

      <div class="sidebar-left__section">
        <ul class="sidebar-left__links">
          <li class="sidebar-left__link">
            <LinkTo
              @route={{this.homepageRoute}}
              class={{this.isActiveLink this.homepageRoute}}
            >
              {{icon "home"}}
              {{i18n (themePrefix "sidebar.left.home")}}
            </LinkTo>
          </li>

          {{#if this.currentUser}}
            <li
              class={{concatClass
                "sidebar-left__link sidebar-left__messages"
                (if this.isMovedToHeader "hidden")
              }}
            >
              <LinkTo
                @route="userPrivateMessages"
                @model={{this.currentUser}}
                class={{this.isActiveLink "userPrivateMessages"}}
              >
                {{icon "m-email"}}
                <span class="sidebar-left__label">
                  {{i18n (themePrefix "sidebar.left.messages")}}
                  {{#unless
                    (eq
                      this.currentUser.new_personal_messages_notifications_count
                      0
                    )
                  }}
                    <span class="badge-notification">
                      {{this.currentUser.new_personal_messages_notifications_count}}
                    </span>
                  {{/unless}}
                </span>
              </LinkTo>
              <DButton
                @action={{this.toggleMenu}}
                @icon="ellipsis-h"
                class={{concatClass
                  "sidebar-left__messages-more"
                  (if this.menuIsActive "active")
                }}
              />
              <ul
                class={{concatClass
                  "sidebar-left__messages-menu"
                  (unless this.menuIsActive "hidden")
                }}
                style={{this.concatStyle}}
              >
                <li>
                  <a
                    href={{concat "/u/" this.currentUser.username "/messages"}}
                  >
                    {{icon "m-inbox"}}
                    <span>Go to inbox</span>
                  </a>
                </li>
                <li>
                  <a href="/new-message">
                    {{icon "m-post_add"}}
                    <span>New message</span>
                  </a>
                </li>
                <li>
                  <a href {{on "click" this.toggleMoveToHeader}}>
                    {{icon "m-arrow_outward"}}
                    <span>Move to header</span>
                  </a>
                </li>
              </ul>
            </li>

            <li class="sidebar-left__link">
              <LinkTo
                @route="discovery.unread"
                class={{this.isActiveLink "discovery.unread"}}
              >
                {{icon "m-feed"}}
                <span class="sidebar-left__label">
                  {{i18n (themePrefix "sidebar.left.following")}}
                </span>
              </LinkTo>
            </li>

            {{#if this.currentUser.can_review}}
              <li class="sidebar-left__link">
                <LinkTo @route="review" class={{this.isActiveLink "review"}}>
                  {{icon "flag"}}
                  <span class="sidebar-left__label">
                    {{i18n (themePrefix "sidebar.left.review")}}
                    {{#unless (eq this.currentUser.reviewable_count 0)}}
                      <span class="badge-notification">
                        {{this.currentUser.reviewable_count}}
                      </span>
                    {{/unless}}
                  </span>
                </LinkTo>
              </li>
            {{/if}}

            {{#if this.currentUser.admin}}
              <li class="sidebar-left__link">
                <LinkTo @route="admin" class={{this.isActiveLink "admin"}}>
                  {{icon "wrench"}}
                  <span class="sidebar-left__label">
                    {{i18n (themePrefix "sidebar.left.admin")}}
                  </span>
                </LinkTo>
              </li>
            {{/if}}

            <li class="sidebar-left__link">
              <a {{on "click" this.createTopic}} role="button" class="sidebar-left__new">
                {{icon "m-add_box"}}
                <span class="sidebar-left__label">
                  {{i18n (themePrefix "sidebar.left.new_topic")}}
                </span>
              </a>
            </li>
          {{/if}}
        </ul>
      </div>
      <SidebarLeftCategories />
      <SidebarLeftFooter />
    </nav>
  </template>
}
