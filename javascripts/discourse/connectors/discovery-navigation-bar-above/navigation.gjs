import Component from "@glimmer/component";
// import { tracked } from "@glimmer/tracking";
// import { concat, get } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { service } from "@ember/service";
// import { htmlSafe } from "@ember/template";
// import { eq, or } from "truth-helpers";
// import avatar from "discourse/helpers/avatar";
// import categoryLink from "discourse/helpers/category-link";
// import concatClass from "discourse/helpers/concat-class";
// import number from "discourse/helpers/number";
// import replaceEmoji from "discourse/helpers/replace-emoji";
import { ajax } from "discourse/lib/ajax";
// import Category from "discourse/models/category";
import i18n from "discourse-common/helpers/i18n";

export default class Breadcrumbs extends Component {
  @service router;
  @service site;

  routeType() {
    switch (this.router.currentRouteName) {
      case "discovery.latest":
      case "discovery.hot":
      case "discovery.top":
      case "discovery.new":
      case "discovery.unread":
        return "home";
      case "discovery.category":
        return "category";
      case "discovery.categories":
        return "categories";
      default:
        return null;
    }
  }

  get isHomepage() {
    return this.routeType() == "home";
  }

  get isCategoryView() {
    return this.routeType() == "category";
  }

  get isCategoryList() {
    return this.routeType() == "categories";
  }

  get categoryName() {
    return this.router?.currentRoute?.attributes?.category?.name || "Category";
  }

  @action
  home() {
    console.log(this.router.transitionTo);
    this.router.transitionTo("/")
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
          <div data-badge-type="emoji" data-clickable="true" class="badge" {{on "click" this.home}}>
            📂
          </div>
          {{this.categoryName}}
        </h2>
      {{else if this.isCategoryList}}
        <h2 class="breadcrumbs__title">
          <div data-badge-type="emoji" data-clickable="true" class="badge" {{on "click" this.home}}>
            🗃️
          </div>
          Categories
        </h2>
      {{/if}}
    </div>
  </template>
}
