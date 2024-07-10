import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat } from "@ember/helper";
import { action } from "@ember/object";
import { htmlSafe } from "@ember/template";
import { eq } from "truth-helpers";
import avatar from "discourse/helpers/avatar";
import concatClass from "discourse/helpers/concat-class";
import number from "discourse/helpers/number";
import { ajax } from "discourse/lib/ajax";
import i18n from "discourse-common/helpers/i18n";

export default class BlockTopContributors extends Component {
  @tracked topContributors = null;
  @tracked period = this.args?.period || "monthly";
  @tracked count = parseInt(this.args?.count, 10) || 10;

  periods = [
    { value: "all", title: "js.filters.top.all.title" },
    { value: "yearly", title: "js.filters.top.yearly.title" },
    { value: "quarterly", title: "js.filters.top.quarterly.title" },
    { value: "monthly", title: "js.filters.top.monthly.title" },
    { value: "weekly", title: "js.filters.top.weekly.title" },
    { value: "daily", title: "js.filters.top.today" },
  ];

  constructor() {
    super(...arguments);
    this.fetchTopContributors(this.period, this.count);
  }

  willDestroy() {
    super.willDestroy(...arguments);
    this.topContributors = null;
  }

  get size() {
    if (this.args.size) {
      return `block--${this.args.size}`;
    }
  }

  get variant() {
    if (this.args.variant) {
      switch (this.args.variant) {
        case "b":
          return `block--${this.args.variant}`;
      }
    }
  }

  async fetchTopContributors(period, count) {
    try {
      const response = await ajax(`/leaderboard/7.json?period=${period}`);
      this.topContributors = response.users.slice(0, count);
    } catch (_) {
      const response = await ajax(
        `/directory_items.json?period=${period}&order=likes_received`
      );
      response.directory_items = response.directory_items.map((item) => {
        let user = item.user;
        delete item.user;
        return { ...item, ...user };
      });

      this.topContributors = response.directory_items.slice(0, count);
    }
  }

  @action
  updatePeriod(event) {
    const newPeriod = event.target.value;
    this.period = newPeriod;
    this.fetchTopContributors(this.period, this.count);
  }

  <template>
    <div
      class={{concatClass
        "block block-chart block-top-contributors"
        this.size
        this.variant
      }}
    >
      <div class="block-chart__header">
        <h3>
          {{i18n (themePrefix "blocks.top_contributors.title")}}
        </h3>

        {{yield this.topContributors}}

        <select onchange={{this.updatePeriod}}>
          {{#each this.periods as |period|}}
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
                href={{concat "/u/" topContributor.username}}
                data-user-card={{topContributor.username}}
              >
                {{avatar topContributor imageSize="medium"}}
              </a>
            </div>
            <div class="block-chart__info">
              <div class="block-chart__title">
                <a
                  href={{concat "/u/" topContributor.username}}
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
        <a href={{concat "/leaderboard/7&period=" this.period}}>
          {{i18n "js.show_more"}}
        </a>
      </div>
    </div>
  </template>
}
