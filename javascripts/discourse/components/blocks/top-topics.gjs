import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat, get } from "@ember/helper";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import { eq, or } from "truth-helpers";
import avatar from "discourse/helpers/avatar";
import categoryLink from "discourse/helpers/category-link";
import concatClass from "discourse/helpers/concat-class";
import number from "discourse/helpers/number";
import replaceEmoji from "discourse/helpers/replace-emoji";
import { ajax } from "discourse/lib/ajax";
import Category from "discourse/models/category";
import i18n from "discourse-common/helpers/i18n";

export default class BlockTopTopics extends Component {
  @tracked topTopics = null;
  @tracked period = "daily";
  @tracked count = parseInt(this.args?.count, 10) || 10;

  constructor() {
    super(...arguments);

    this.fetchTopTopics(this.period, this.count);
  }

  willDestroy() {
    super.willDestroy(...arguments);
    this.topTopics = null;
  }

  get format() {
    if (this.args.format) {
      return `block--${this.args.format}`;
    }
  }

  fetchTopTopics(period, count) {
    ajax(`/top.json?period=${period}`).then((data) => {
      this.topTopics = data.topic_list.topics.slice(0, count);
      this.topTopics.forEach((topic) => {
        topic["category"] = Category.findById(topic.category_id);
      });
    });
  }

  @action
  updatePeriod(event) {
    const newPeriod = event.target.value;
    this.period = newPeriod;
    this.fetchTopTopics(this.period, this.count);
  }

  <template>
    <div class={{concatClass "block block-chart block-top-topics" this.format}}>
      <div class="block-chart__header">
        <h3>
          {{i18n (themePrefix "blocks.top_topics.title")}}
        </h3>

        {{yield this.topTopics}}

        <select onchange={{this.updatePeriod}}>
          <option value="all">All-time</option>
          <option value="yearly">Yearly</option>]
          <option value="quarterly">Quarterly</option>
          <option value="monthly">Monthly</option>
          <option value="weekly">Weekly</option>
          <option value="daily" selected>Today</option>
        </select>
      </div>
      <ol class="block-chart__list">
        {{#each this.topTopics as |topic|}}
          <li class="block-chart__item">
            <div class="block-chart__info">
              <div class="block-chart__title">
                <a href={{concat "/t/" topic.slug}}>
                  {{replaceEmoji (htmlSafe topic.fancy_title)}}
                </a></div>
              <div class="block-chart__details">
                {{~categoryLink topic.category~}}
                <ul class="block-chart__stats">
                  {{#unless (eq topic.like_count 0)}}
                    <li>
                      <a
                        href={{concat "/t/" topic.slug}}
                        class={{if topic.liked "--liked"}}
                      >
                        {{number topic.like_count}}
                      </a>
                    </li>
                  {{/unless}}
                  {{#unless (eq topic.posts_count 1)}}
                    <li>
                      <a href={{concat "/t/" topic.slug}}>
                        {{number topic.posts_count}}
                      </a>
                    </li>
                  {{/unless}}
                </ul>
              </div>
            </div>
          </li>
        {{/each}}
      </ol>
      <div class="block-chart__expand">
        <a href={{concat "/top?period=" this.period}}>
          {{i18n (themePrefix "blocks.expand")}}
        </a>
      </div>
    </div>
  </template>
}
