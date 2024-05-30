import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { LinkTo } from "@ember/routing";
import { service } from "@ember/service";
import { eq, not, or } from "truth-helpers";
import categoryLink from "discourse/helpers/category-link";
import concatClass from "discourse/helpers/concat-class";
import Category from "discourse/models/category";
import i18n from "discourse-common/helpers/i18n";

// import bodyClass from "discourse/helpers/body-class";

export default class CentralNavigation extends Component {
  @service currentUser;
  @service router;
  @service site;

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
    {{log this.router}}
    <div class="c-navigation">

      <nav>
        <ul>
          <li>
            <LinkTo @route="discovery.latest" data-name="home">
              <span>
                {{i18n "js.home"}}
              </span>
            </LinkTo>
          </li>

          {{!-- <li>
            <LinkTo @route="discovery.latest" data-name="topics">
              <span>
                {{i18n "js.topic.list"}}

              </span>
            </LinkTo>
          </li> --}}

          {{#if this.currentUser}}
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

            {{#if this.currentUser.admin}}
              <li class="c-navigation__admin">
                <LinkTo @route="admin.dashboard.general" data-name="admin">
                  <span>
                    {{i18n "js.admin_title"}}
                  </span>
                </LinkTo>

                <ul>
                  <li>
                    Dashboard
                  </li>
                  <li>
                    <a href="/admin/site_settings/">
                      Settings
                    </a>
                  </li>
                  <li>
                    <a href="/admin/users/">
                      Users
                    </a>
                  </li>
                  <li>
                    <a href="/admin/badges/">
                      Badges
                    </a>
                  </li>

                  <li>
                    <a href="/admin/emails/">
                      Emails
                    </a>
                  </li>

                  <li>
                    <a href="/admin/logs/">
                      Logs
                    </a>
                  </li>

                  <li>
                    <a href="/admin/customize/themes">
                      Customize
                    </a>
                  </li>

                  <li>
                    <a href="/admin/api/">
                      API
                    </a>
                  </li>

                  <li>
                    <a href="/admin/backups/">
                      Backups
                    </a>
                  </li>

                  <li>
                    <a href="/admin/plugins/">
                      Plugins
                    </a>
                  </li>
                </ul>
              </li>
            {{/if}}

          {{/if}}

          <li class="c-navigation__categories">
            <LinkTo @route="discovery.categories" data-name="categories">
              <span>
                {{i18n "js.search.categories"}}
              </span>
            </LinkTo>
            <ul>
              {{log "site" this.site}}
              {{#each this.categories as |category|}}
                {{#unless category.parent_category_id}}

                  <li
                    {{!-- class={{concatClass
                      (unless
                        (eq category.newTopicsCount 0) "unread-notification"
                      )
                    }} --}}
                    class={{if
                      (eq
                        this.router.currentRoute.attributes.category.id
                        category.id
                      )
                      "active"
                    }}
                  >
                    {{~categoryLink category~}}

                    {{#if category.subcategory_ids}}
                      <ul class="c-navigation__subcategories">
                        {{#each category.subcategory_ids as |subcategory|}}
                          <li>
                            {{log "subcategory" subcategory.name}}
                            {{~categoryLink subcategory~}}
                          </li>
                        {{/each}}
                      </ul>
                    {{/if}}
                  </li>
                {{/unless}}
              {{/each}}
            </ul>
          </li>
        </ul>
      </nav>

      <footer>
      </footer>

    </div>
  </template>
}
