import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
// import { on } from "@ember/modifier";
// import { action } from "@ember/object";
import { service } from "@ember/service";
// import { htmlSafe } from "@ember/template";
// import { eq } from "truth-helpers";
import bodyClass from "discourse/helpers/body-class";
// import categoryBadge from "discourse/helpers/category-badge";
import i18n from "discourse-common/helpers/i18n";

export default class Breadcrumbs extends Component {
  @service router;
  @service site;
  @service discovery;
  @tracked routeType;

  get currentPage() {
    switch (true) {
      case this.router.currentRouteName.includes("userPrivateMessages"):
        return "js.groups.messages";
      case this.router.currentRouteName.startsWith("admin"):
        return "js.admin_title";
      case this.router.currentRouteName.startsWith("chat"):
        return "js.chat.heading";
      case this.router.currentRouteName === "userNotifications.responses" ||
        this.router.currentRouteName === "userNotifications.mentions":
        return "js.groups.mentions";
      case this.router.currentRouteName === "userActivity.bookmarks":
        return "js.user.bookmarks";
      case this.router?.currentRoute?.parent?.name === "docs":
        return "js.docs.title";
      case this.router?.currentRoute?.parent?.name === "preferences":
        return "js.user.preferences.title";
      default:
        return null;
    }
  }

  get currentPageClass() {
    return this.router.currentRouteName
      .replace(/\./g, "-")
      .replace(/([a-z])([A-Z])/g, "$1-$2")
      .toLowerCase();
  }

  <template>
    {{#if this.currentPage}}
      {{bodyClass this.currentPageClass}}
      <div class="breadcrumbs">
        <h2 class="breadcrumbs__title">
          {{i18n this.currentPage}}
        </h2>
      </div>
    {{/if}}
  </template>
}
