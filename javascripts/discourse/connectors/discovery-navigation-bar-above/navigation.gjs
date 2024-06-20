import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { capitalize } from "@ember/string";
import { eq } from "truth-helpers";
import i18n from "discourse-common/helpers/i18n";

export default class Breadcrumbs extends Component {
  @service router;
  @service site;

  @tracked routeType;

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

  get isCategoryView() {
    this.updateRouteType();
    return this.routeType === "category";
  }

  get isCategoryList() {
    this.updateRouteType();
    return this.routeType === "categories";
  }

  get categoryName() {
    return this.router?.currentRoute?.attributes?.category?.name || "Category";
  }

  get categoryBadge() {
    const defaultBadge = settings.default_category_badge || "📁";

    const badge = settings.category_icons?.find(
      (category) =>
        category.id[0] === this.router?.currentRoute?.attributes?.category?.id
    )?.emoji;

    if (!badge) {
      return defaultBadge;
    }

    try {
      // check for valid emoji
      const regex = /\p{Emoji}/u;
      if (regex.test(badge)) {
        return badge;
      }
      return defaultBadge;
    } catch (e) {
      // \p{Emoji} not supported -> skip validation
      return badge;
    }
  }

  @action
  home() {
    this.router.transitionTo("/");
  }

  <template>
    <div class="breadcrumbs">
      {{#if this.isHomepage}}
        <h2 class="breadcrumbs__title">
          <div data-badge-type="icon" class="badge">
            home
          </div>
          {{i18n "js.home"}}
        </h2>
      {{else if this.isCategoryView}}
        <h2 class="breadcrumbs__title">
          <div
            data-badge-type="emoji"
            data-clickable="true"
            class="badge"
            {{on "click" this.home}}
          >
            {{this.categoryBadge}}
          </div>
          {{this.categoryName}}
        </h2>
      {{else if this.isCategoryList}}
        <h2 class="breadcrumbs__title">
          <div
            data-badge-type="emoji"
            data-clickable="true"
            class="badge"
            {{on "click" this.home}}
          >
            🗃️
          </div>
          {{capitalize (i18n "js.categories.categories_label")}}
        </h2>
      {{/if}}
      <TopicFilter
        @filterType={{this.filterType}}
        @routeType={{this.routeType}}
      />
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
        <option value={{filterOption.name}}  selected={{eq filterOption.name @filterType}}>
          {{i18n filterOption.localization}}
        </option>
      {{/each}}
    </select>
  </template>
}
