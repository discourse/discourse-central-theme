import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
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
import { i18n } from "discourse-i18n";

const PERIODS = [
  { value: "all", title: "js.filters.top.all.title" },
  { value: "yearly", title: "js.filters.top.yearly.title" },
  { value: "quarterly", title: "js.filters.top.quarterly.title" },
  { value: "monthly", title: "js.filters.top.monthly.title" },
  { value: "weekly", title: "js.filters.top.weekly.title" },
  { value: "daily", title: "js.filters.top.today" },
];

export default class TopTopics extends Component {
  @tracked topTopics = [];
  @tracked period = this.args.period || "weekly";

  constructor() {
    super(...arguments);
    this.fetchTopTopics();
  }

  get count() {
    return parseInt(this.args.count, 10) || 10;
  }

  @action
  async fetchTopTopics() {
    const data = await ajax(`/top.json?period=${this.period}`);
    const topTopics = data.topic_list.topics.slice(0, this.count);
    const categoryIds = topTopics.map((topic) => topic.category_id);
    const categories = await Category.asyncFindByIds(categoryIds);

    topTopics.forEach((topic) => {
      topic.category = categories.find(
        (category) => topic.category_id === category.id
      );

      topic.author = data.users.find(
        (user) => user.id === topic.posters[0].user_id
      );
    });

    this.topTopics = topTopics;
  }

  @action
  updatePeriod(event) {
    this.period = event.target.value;
    this.fetchTopTopics();
  }

  <template>
    <div
      class={{concatClass
        "block block-chart block-top-topics"
        (if @size (concat "block--" @size))
      }}
    >
      <div class="block-chart__header">
        <h3>
          {{i18n (themePrefix "blocks.top_topics.title")}}
        </h3>

        {{yield this.topTopics}}

        <select {{on "change" this.updatePeriod}}>
          {{#each PERIODS as |period|}}
            {{#if (eq this.period period.value)}}
              <option value={{period.value}} selected>
                {{i18n period.title}}
              </option>
            {{else}}
              <option value={{period.value}}>
                {{i18n period.title}}
              </option>
            {{/if}}
          {{/each}}
        </select>
      </div>

      <ol class="block-chart__list">
        {{#each this.topTopics as |topic|}}
          <li class="block-chart__item">
            <div class="block-chart__info">
              <div class="block-chart__title">
                <a href="/t/{{topic.slug}}/{{topic.id}}">
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
              </div>

              <ul class="block-chart__stats">
                {{#unless (eq topic.like_count 0)}}
                  <li>
                    <a
                      href="/t/{{topic.slug}}/{{topic.id}}"
                      class={{concatClass (if topic.liked "--liked") "--likes"}}
                    >
                      <span>{{number topic.like_count}}</span>
                    </a>
                  </li>
                {{/unless}}

                {{#unless (eq topic.posts_count 1)}}
                  <li>
                    <a href="/t/{{topic.slug}}/{{topic.id}}" class="--comments">
                      <span>{{number topic.posts_count}}</span>
                    </a>
                  </li>
                {{/unless}}
              </ul>
            </div>
          </li>
        {{/each}}
      </ol>

      <div class="block-chart__expand">
        <a href="/top?period={{this.period}}">
          {{i18n "js.show_more"}}
        </a>
      </div>
    </div>
  </template>
}
