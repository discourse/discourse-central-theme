/** eslint-disable no-unused-vars */
import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat } from "@ember/helper";
import { action } from "@ember/object";
// import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import { eq } from "truth-helpers";
import UserLink from "discourse/components/user-link";
import avatar from "discourse/helpers/avatar";
import categoryLink from "discourse/helpers/category-link";
import concatClass from "discourse/helpers/concat-class";
import formatDate from "discourse/helpers/format-date";
import number from "discourse/helpers/number";
import replaceEmoji from "discourse/helpers/replace-emoji";
import { ajax } from "discourse/lib/ajax";
import Category from "discourse/models/category";
import i18n from "discourse-common/helpers/i18n";

export default class BlockTopTopics extends Component {
  @tracked topTopics = [];
  @tracked period = this.args?.period || "weekly";
  @tracked count = parseInt(this.args?.count, 10) || 10;

  constructor() {
    super(...arguments);

    this.fetchTopTopics(this.period, this.count);
  }

  willDestroy() {
    super.willDestroy(...arguments);
    this.topTopics = null;
  }

  get size() {
    if (this.args.size) {
      return `block--${this.args.size}`;
    }
  }

  @action
  async fetchTopTopics(period, count) {
    let data = await ajax(`/top.json?period=${period}`);
    let topTopics = data.topic_list.topics.slice(0, count);
    let categoryIds = topTopics.map((topic) => topic.category_id);
    let categories = await Category.asyncFindByIds(categoryIds);

    topTopics.forEach((topic) => {
      topic["category"] = categories.find(
        (category) => topic.category_id === category.id
      );

      let author = data.users.find(
        (user) => user.id === topic.posters[0].user_id
      );
      topic.author = author;
    });
    this.topTopics = topTopics;
  }

  @action
  updatePeriod(event) {
    const newPeriod = event.target.value;
    this.period = newPeriod;
    this.fetchTopTopics(this.period, this.count);
  }

  <template>
    <div class={{concatClass "block block-chart block-top-topics" this.size}}>
      <div class="block-chart__header">
        <h3>
          {{i18n (themePrefix "blocks.top_topics.title")}}
        </h3>

        {{yield this.topTopics}}

        <select onchange={{this.updatePeriod}}>
          <option value="all">
            {{i18n "js.filters.top.all.title"}}
          </option>
          <option value="yearly">
            {{i18n "js.filters.top.yearly.title"}}
          </option>
          <option value="quarterly">
            {{i18n "js.filters.top.quarterly.title"}}
          </option>
          <option value="monthly">
            {{i18n "js.filters.top.monthly.title"}}
          </option>
          <option value="weekly" selected>
            {{i18n "js.filters.top.weekly.title"}}
          </option>
          <option value="daily">
            {{i18n "js.filters.top.today"}}
          </option>
        </select>
      </div>

      <ol class="block-chart__list">
        {{#each this.topTopics as |topic|}}
          <li class="block-chart__item">
            <div class="block-chart__info">
              <div class="block-chart__title">
                <a href={{concat "/t/" topic.slug "/" topic.id}}>
                  {{replaceEmoji (htmlSafe topic.fancy_title)}}
                </a>
              </div>
              <div class="block-chart__details">
                <UserLink class="block-chart__avatar" @user={{topic.author}}>
                  {{avatar topic.author imageSize="tiny"}}
                </UserLink>
                <span class="block-chart__metadata">
                  {{formatDate topic.created_at format="tiny" leaveAgo="true"}}
                  {{~categoryLink topic.category~}}
                </span>
                <ul class="block-chart__stats">
                  {{!-- {{#unless (eq topic.like_count 0)}}
                    <li>
                      <a
                        href={{concat "/t/" topic.slug "/" topic.id}}
                        class={{if topic.liked "--liked"}}
                      >
                        {{number topic.like_count}}
                      </a>
                    </li>
                  {{/unless}} --}}
                  {{#unless (eq topic.posts_count 1)}}
                    <li>
                      <a href={{concat "/t/" topic.slug "/" topic.id}}>
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
          {{i18n "js.show_more"}}
        </a>
      </div>
    </div>
  </template>
}
