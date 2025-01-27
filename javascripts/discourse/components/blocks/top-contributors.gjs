import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { htmlSafe } from "@ember/template";
import { eq } from "truth-helpers";
import avatar from "discourse/helpers/avatar";
import concatClass from "discourse/helpers/concat-class";
import number from "discourse/helpers/number";
import { ajax } from "discourse/lib/ajax";
import i18n from "discourse-common/helpers/i18n";

const PERIODS = [
  { value: "all", title: "js.filters.top.all.title" },
  { value: "yearly", title: "js.filters.top.yearly.title" },
  { value: "quarterly", title: "js.filters.top.quarterly.title" },
  { value: "monthly", title: "js.filters.top.monthly.title" },
  { value: "weekly", title: "js.filters.top.weekly.title" },
  { value: "daily", title: "js.filters.top.today" },
];

export default class TopContributors extends Component {
  @tracked topContributors;
  @tracked period = this.args.period || "monthly";

  constructor() {
    super(...arguments);
    this.fetchTopContributors();
  }

  get count() {
    return parseInt(this.args.count, 10) || 10;
  }

  get variant() {
    switch (this.args.variant) {
      case "b":
        return `block--${this.args.variant}`;
    }
  }

  async fetchTopContributors() {
    try {
      const data = await ajax(
        `/leaderboard/${settings.leaderboard_id}.json?period=${this.period}`
      );
      this.topContributors = data.users.slice(0, this.count);
    } catch {
      const data = await ajax(
        `/directory_items.json?period=${this.period}&order=likes_received`
      );
      data.directory_items = data.directory_items.map((item) => {
        const user = item.user;
        delete item.user;
        return { ...item, ...user };
      });

      this.topContributors = data.directory_items.slice(0, this.count);
    }
  }

  @action
  updatePeriod(event) {
    this.period = event.target.value;
    this.fetchTopContributors();
  }

  <template>
    <div
      class={{concatClass
        "block block-chart block-top-contributors"
        (if @size (concat "block--" @size))
        this.variant
      }}
    >
      <div class="block-chart__header">
        <h3>
          {{i18n (themePrefix "blocks.top_contributors.title")}}
        </h3>

        {{yield this.topContributors}}

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
        {{#each this.topContributors as |topContributor|}}
          <li class="block-chart__item">
            <div class="block-chart__img">
              <a
                href="/u/{{topContributor.username}}"
                data-user-card={{topContributor.username}}
              >
                {{avatar topContributor imageSize="medium"}}
              </a>
            </div>
            <div class="block-chart__info">
              <div class="block-chart__title">
                <a
                  href="/u/{{topContributor.username}}"
                  data-user-card={{topContributor.username}}
                >
                  {{htmlSafe topContributor.username}}
                </a>
              </div>
              <div class="block-chart__details">
                <span>
                  {{number topContributor.total_score}}
                  {{i18n (themePrefix "blocks.top_contributors.unit")}}
                </span>
              </div>
            </div>
          </li>
        {{/each}}
      </ol>

      <div class="block-chart__expand">
        <a
          href="/leaderboard/{{settings.leaderboard_id}}&period={{this.period}}"
        >
          {{i18n "js.show_more"}}
        </a>
      </div>
    </div>
  </template>
}
