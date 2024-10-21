import Component from "@glimmer/component";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import categoryColorVariable from "discourse/helpers/category-color-variable";
import categoryLink from "discourse/helpers/category-link";
import concatClass from "discourse/helpers/concat-class";
import formatDate from "discourse/helpers/format-date";

export default class CentralCategories extends Component {
  @service router;
  @service discovery;

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
    {{#if this.discovery.category.subcategories}}
      <div class="c-categories">
        {{#each this.discovery.category.subcategories as |subcategory|}}
          {{! template-lint-disable no-invalid-interactive }}
          <div
            {{on "click" (fn this.navigate subcategory.url)}}
            data-notification-level={{subcategory.notificationLevelString}}
            style={{categoryColorVariable subcategory.color}}
            class={{concatClass
              "c-categories__item"
              (if subcategory.isMuted "--muted")
            }}
          >
            <h3
              class={{concatClass
                "c-categories__item-heading"
                (if subcategory.read_restricted "--locked")
              }}
            >
              {{categoryLink subcategory}}
            </h3>

            {{#if subcategory.description}}
              <div class="c-categories__item-description">
                {{htmlSafe subcategory.description}}
              </div>
            {{/if}}

            {{#if subcategory.topics}}
              <ul class="c-categories__item-topics">
                {{#each subcategory.topics as |topic|}}
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
            {{/if}}
          </div>
        {{/each}}
      </div>
    {{/if}}
  </template>
}
