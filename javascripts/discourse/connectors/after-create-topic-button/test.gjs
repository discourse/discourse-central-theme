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

export default class DiscoveryBreadcrumbs extends Component {
  @service router;
  @service site;
  @service discovery;
  @tracked routeType;

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
    return (
      this.router.currentRoute.parent.name === "discovery" &&
      this.router.currentRouteName !== "discovery.categories" &&
      this.router.currentRouteName !== "discovery.category"
    );
  }

  get shouldRenderFilters() {
    return this.router.currentRouteName !== "discovery.categories";
  }

  @action
  home() {
    this.router.transitionTo("/");
  }

  <template>
    {{!-- {{bodyClass this.className}} --}}
    <div class="breadcrumbs">
      {{#if this.isHomepage}}
        <h2 class="breadcrumbs__title" data-name="home">
          {{i18n "js.home"}}
        </h2>
      {{else if this.discovery.category}}
        <div class="breadcrumbs__category">
          <h2 class="breadcrumbs__title">
            {{categoryBadge this.discovery.category}}
          </h2>
          {{#if this.discovery.category.description}}
            <div class="breadcrumbs__desc">
              {{htmlSafe this.discovery.category.description}}
            </div>
          {{/if}}
        </div>
      {{else if (eq this.router.currentRouteName "discovery.categories")}}
        <h2 class="breadcrumbs__title">
          {{i18n "js.filters.categories.title"}}
        </h2>

      {{/if}}

      {{#if this.shouldRenderFilters}}
        <TopicFilter
          @filterType={{this.filterType}}
          @routeType={{this.routeType}}
        />
      {{/if}}
    </div>
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