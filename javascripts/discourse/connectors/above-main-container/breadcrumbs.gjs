import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import { eq } from "truth-helpers";
import bodyClass from "discourse/helpers/body-class";
import categoryBadge from "discourse/helpers/category-badge";
import i18n from "discourse-common/helpers/i18n";

export default class Breadcrumbs extends Component {
  @service router;
  @service site;
  @service discovery;
  @tracked routeType;

  get pageName() {
    switch (true) {
      case this.router.currentRouteName.includes("userPrivateMessages"):
        return "js.groups.messages";
      // case this.router.currentRouteName === "discovery.categories":
      //   return "js.filters.categories.title";
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
      default:
        return null;
    }
  }

  get shouldRenderBreadcrumbs() {
    return this.pageName || this.isHomepage || this.discovery.category;
  }

  get shouldRenderFilters() {
    return this.discovery.category || this.isHomepage;
  }

  get className() {
    return this.router.currentRouteName
      .replace(/\./g, "-")
      .replace(/([a-z])([A-Z])/g, "$1-$2")
      .toLowerCase();
  }

  @action
  updateRouteType() {
    if (this.router?.currentRoute?.parent?.name === "discovery") {
      switch (this.router?.currentRoute?.localName) {
        case "latest":
        case "hot":
        case "top":
        case "new":
        case "unread":
          this.routeType = "home";
          break;
        case "category":
        case "latestCategory":
        case "hotCategory":
        case "topCategory":
        case "newCategory":
        case "unreadCategory":
          this.routeType = "category";
          break;
        case "categories":
          this.routeType = "categories";
          break;
        default:
          this.routeType = null;
          break;
      }
    } else {
      this.routeType = null;
    }
  }

  get filterType() {
    if (this.router?.currentRoute?.localName === "categories") {
      return "categories";
    }
    return this.router?.currentRoute?.attributes?.filterType || "";
  }

  get isHomepage() {
    this.updateRouteType();
    return this.routeType === "home";
  }

  @action
  home() {
    this.router.transitionTo("/");
  }

  <template>
    {{#if this.pageName}}
      {{bodyClass this.className}}

      <div class="breadcrumbs">

        <h2 class="breadcrumbs__title">
          {{!-- <div
            data-badge-type="emoji"
            data-clickable="true"
            class="badge"
            {{on "click" this.home}}
          >

          </div> --}}
          {{i18n this.pageName}}
        </h2>

        {{#if this.shouldRenderFilters}}
          <TopicFilter
            @filterType={{this.filterType}}
            @routeType={{this.routeType}}
          />
        {{/if}}
      </div>
    {{/if}}
  </template>
}
class TopicFilter extends Component {
  @service router;
  @service site;

  @tracked filterOptions;

  constructor() {
    super(...arguments);

    this.filterOptions =
      this.site.siteSettings?.top_menu?.split("|").map((item) => {
        return { name: item, localization: `js.filters.${item}.title` };
      }) || [];
  }

  @action
  filterTopics(event) {
    const routeType = this.args.routeType;
    const category = this.router?.currentRoute?.attributes?.category;

    if (routeType === "category" && event.target.value !== "categories") {
      this.router.transitionTo(
        `/c/${category.slug}/${category.id}/l/${event.target.value}`
      );
    } else {
      this.router.transitionTo(`/${event.target.value}`);
    }
  }

  <template>
    <select
      class="breadcrumbs__select"
      value={{@filterType}}
      onchange={{this.filterTopics}}
    >
      {{#each this.filterOptions as |filterOption|}}
        <option
          value={{filterOption.name}}
          selected={{eq filterOption.name @filterType}}
        >
          {{i18n filterOption.localization}}
        </option>
      {{/each}}
    </select>
  </template>
}
