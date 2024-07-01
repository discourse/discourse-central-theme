import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { LinkTo } from "@ember/routing";
import { service } from "@ember/service";
import { eq } from "truth-helpers";
import bodyClass from "discourse/helpers/body-class";
import categoryLink from "discourse/helpers/category-link";
// import concatClass from "discourse/helpers/concat-class";
import Category from "discourse/models/category";
import i18n from "discourse-common/helpers/i18n";

export default class CentralNavigation extends Component {
  @service currentUser;
  @service router;
  @service site;
  @service siteSettings;
  @service discovery;

  @tracked categories = [];

  constructor() {
    super(...arguments);
    this.fetchAllCategories();
  }

  @action
  async fetchAllCategories() {
    let page = 1;
    let hasMoreCategories = true;
    let categories = [];

    while (hasMoreCategories) {
      let response = await fetch(`/categories.json?page=${page}`);
      let data = await response.json();

      if (data.category_list.categories.length > 0) {
        categories = [...categories, ...data.category_list.categories];
        page++;
      } else {
        hasMoreCategories = false;
      }
    }

    // parent categories only
    categories = categories.filter(
      (category) => category.parent_category_id === undefined
    );

    // ready subcategory IDs for async call
    let subcategoryIds = [];
    categories.forEach((category) => {
      if (category.subcategory_count > 0) {
        subcategoryIds.push(...category.subcategory_ids);
      }
    });

    // fetch subcategories
    let subcategories = await Category.asyncFindByIds(subcategoryIds);

    // map subcategory objects to respective categories
    categories = categories.map((category) => {
      if (category.subcategory_count > 0) {
        const updatedSubcategoryIds = category.subcategory_ids.map((id) => {
          const subcategory = subcategories.find((sub) => sub.id === id);
          return { ...subcategory };
        });
        return { ...category, subcategory_ids: updatedSubcategoryIds };
      }
      return category;
    });

    // trigger render
    this.categories = categories;

    // console.log(this.categories);
    // console.log(subcategoryIds);
  }

  <template>
    {{!log
      this.discovery
      this.router
      this.siteSettings.lazy_load_categories_groups
    }}
    {{#if (eq this.router.currentRouteName "userActivity.assigned")}}
      {{bodyClass "user-assigned-page"}}
    {{/if}}
    <nav class="c-navigation">
      <ul class="c-navigation__main">
        <li>
          <LinkTo @route="discovery.latest" data-name="home">
            <span>
              {{i18n "js.home"}}
            </span>
          </LinkTo>
        </li>

        <li>
          <LinkTo @route="discovery.categories" data-name="categories">
            <span>
              {{i18n "js.search.categories"}}
            </span>
          </LinkTo>
        </li>

        <li>
          <LinkTo @route="tags.index" data-name="tags">
            <span>
              {{i18n "js.search.tags"}}
            </span>
          </LinkTo>
        </li>

        {{#if this.siteSettings.docs_enabled}}
          <li>
            <LinkTo @route="docs.index" data-name="docs">
              <span>
                {{i18n "js.docs.title"}}
              </span>
            </LinkTo>
          </li>
        {{/if}}

        {{#if this.currentUser}}
          <li>
            <LinkTo @route="chat.browse" data-name="chat">
              <span>
                {{i18n "js.chat.heading"}}
              </span>
            </LinkTo>
          </li>
        {{/if}}

        {{!-- <li>
            <LinkTo @route="discovery.latest" data-name="topics">
              <span>
                {{i18n "js.topic.list"}}

              </span>
            </LinkTo>
          </li> --}}

      </ul>

      {{#if this.currentUser}}

        <h6>
          You
        </h6>
        <ul class="c-navigation__you">
          <li>
            <a
              href="/filter?q=in:watching,tracking"
              {{!-- @model={{this.currentUser}} --}}
              data-name="following"
            >
              <span>
                Following
              </span>
            </a>
          </li>

          <li>
            <LinkTo
              @route="userNotifications.responses"
              @model={{this.currentUser}}
              data-name="mentions"
            >
              <span>
                {{i18n "js.groups.mentions"}}
              </span>
            </LinkTo>
          </li>

          <li>
            <LinkTo
              @route="userActivity.bookmarks"
              @model={{this.currentUser}}
              data-name="bookmarks"
            >
              <span>
                {{i18n "js.user.bookmarks"}}
              </span>
            </LinkTo>
          </li>

          <li>
            <LinkTo
              @route="userPrivateMessages"
              @model={{this.currentUser}}
              data-name="messages"
            >
              <span>
                {{i18n "js.groups.messages"}}
              </span>
            </LinkTo>
          </li>

          {{#if this.siteSettings.assign_enabled}}
            <li>
              <LinkTo
                @route="userActivity.assigned"
                @model={{this.currentUser}}
                data-name="assigned"
              >
                <span>
                  Assigned
                </span>
              </LinkTo>
            </li>
          {{/if}}

          {{#if this.currentUser.admin}}
            <li>
              <LinkTo @route="admin.dashboard.general" data-name="admin">
                <span>
                  {{i18n "js.admin_title"}}
                </span>
              </LinkTo>
            </li>
          {{/if}}

        </ul>
      {{/if}}

      <h6>
        {{i18n "js.search.categories"}}
      </h6>
      <ul class="c-navigation__categories">
        {{#each this.categories as |category|}}
          {{#unless category.parent_category_id}}

            <li
              {{!-- class={{concatClass
                      (unless
                        (eq category.newTopicsCount 0) "unread-notification"
                      )
                    }} --}}
              class={{if
                (eq this.router.currentRoute.attributes.category.id category.id)
                "active"
              }}
            >
              {{~categoryLink category~}}

              {{#if category.subcategory_ids}}
                <ul class="c-navigation__subcategories">
                  {{#each category.subcategory_ids as |subcategory|}}
                    <li>
                      {{~categoryLink subcategory~}}
                    </li>
                  {{/each}}
                </ul>
              {{/if}}
            </li>
          {{/unless}}
        {{/each}}
      </ul>
    </nav>
  </template>
}
