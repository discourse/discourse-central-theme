import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
// import { tracked } from "@glimmer/tracking";
// import { concat, get } from "@ember/helper";
// import { action } from "@ember/object";
import { service } from "@ember/service";
// import { htmlSafe } from "@ember/template";
// import { eq, or } from "truth-helpers";
// import avatar from "discourse/helpers/avatar";
// import categoryLink from "discourse/helpers/category-link";
// import concatClass from "discourse/helpers/concat-class";
// import number from "discourse/helpers/number";
// import replaceEmoji from "discourse/helpers/replace-emoji";
// import { ajax } from "discourse/lib/ajax";
// import Category from "discourse/models/category";
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
  }

  <template>
    <div class="breadcrumbs">
      {{#if this.isHomepage}}
        <h2 data-name="home" class="breadcrumbs__title">
          {{i18n "js.home"}}
        </h2>
      {{/if}}
    </div>
  </template>
}
