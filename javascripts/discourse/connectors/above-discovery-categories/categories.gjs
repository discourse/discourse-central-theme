import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
// eslint-disable-next-line no-unused-vars
import { concat, fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import { htmlSafe } from "@ember/template";
// eslint-disable-next-line no-unused-vars
import { eq } from "truth-helpers";
import categoryColorVariable from "discourse/helpers/category-color-variable";
import categoryLink from "discourse/helpers/category-link";
import concatClass from "discourse/helpers/concat-class";
import formatDate from "discourse/helpers/format-date";
import i18n from "discourse-common/helpers/i18n";

export default class CentralCategories extends Component {
  @service currentUser;
  @service router;
  @service discovery;
  @service site;

  @tracked categories = this.args.outletArgs.categories;

  @action
  navigate(url, event) {
    const anchor = event.target.closest("a, button");

    if (anchor) {
      return;
    }
    event.preventDefault();
    this.router.transitionTo(url);
  }

  <template>
    {{!log this.categories}}
    <div class="c-categories">
      {{#each this.categories as |category|}}
        {{! template-lint-disable no-invalid-interactive }}

        <div
          data-notification-level={{category.notificationLevelString}}
          style={{categoryColorVariable category.color}}
          class="c-categories__item {{if category.isMuted '--muted'}}"
          {{on "click" (fn this.navigate category.url)}}
        >
          <h3
            class={{concatClass
              "c-categories__item-heading"
              (if category.read_restricted "--locked")
            }}
          >
            {{categoryLink category}}
          </h3>

          {{#if category.description}}
            <div class="c-categories__item-description">
              {{htmlSafe category.description}}
            </div>
          {{/if}}

          {{#if category.subcategories}}
            <div class="c-categories__item-subcategories">
              {{#each category.subcategories as |subcategory|}}
                {{categoryLink subcategory}}
              {{/each}}
            </div>
          {{/if}}

          {{#if category.topics}}

            <div class="c-categories__item-topics">
              <ul>
                {{#each category.topics as |topic|}}
                  <li>
                    <a href={{topic.lastUnreadUrl}}>
                      <span>{{htmlSafe topic.fancyTitle}}</span>
                      <span class="c-categories__item-metadata">
                        {{formatDate topic.last_posted_at format="tiny"}}
                      </span>
                    </a>
                  </li>
                {{/each}}
              </ul>
              <a href={{category.url}} class="c-categories__item-more">
                {{i18n
                  (themePrefix "categories.category.view_all_topics")
                  count=category.topic_count
                }}
              </a>
            </div>
          {{/if}}

        </div>
      {{/each}}
    </div>
  </template>
}
